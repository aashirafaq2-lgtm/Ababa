import { Router, Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import { signToken, authenticateToken, AuthenticatedRequest } from '../../middleware/auth';
import {
  findUserByIdentity, findUserById, createUser, createProfile, findProfileByUserId,
  updateProfile, updateUserPassword, deleteUserAccount
} from '../../database/pg_service';

const router = Router();

// 1. Sign Up
router.post('/signup', async (req: Request, res: Response) => {
  try {
    const { identity, password, fullName, phone, countryCode } = req.body;
    if (!identity || !password)
      return res.status(400).json({ error: 'Identity and password are required', code: 'INVALID_INPUT' });
    if (password.length < 6)
      return res.status(400).json({ error: 'Password must be at least 6 characters long', code: 'WEAK_PASSWORD' });

    const cleanIdentity = identity.trim().toLowerCase();
    const existing = await findUserByIdentity(cleanIdentity);
    if (existing)
      return res.status(409).json({ error: 'User with this phone/email already exists', code: 'USER_EXISTS' });

    const passwordHash = bcrypt.hashSync(password, 10);
    const boxCode = 'AB-' + Math.floor(1000 + Math.random() * 9000);

    const newUser = await createUser({ identity: cleanIdentity, password_hash: passwordHash, role: 'CUSTOMER' });
    const newProfile = await createProfile({
      user_id: newUser.id,
      full_name: fullName || 'Valued Customer',
      phone: phone || cleanIdentity,
      email: cleanIdentity.includes('@') ? cleanIdentity : '',
      country_code: countryCode || '+218',
      box_code: boxCode,
    });

    const token = signToken({ id: newUser.id, role: 'CUSTOMER', identity: cleanIdentity, box_code: boxCode });
    res.status(201).json({
      message: 'Account registered successfully',
      token,
      user: { id: newUser.id, identity: cleanIdentity, fullName: newProfile.full_name, boxCode: newProfile.box_code, role: 'CUSTOMER' },
    });
  } catch (error) {
    console.error('Sign up error:', error);
    res.status(500).json({ error: 'Internal server error during registration', code: 'SERVER_ERROR' });
  }
});

// 2. Sign In
router.post('/signin', async (req: Request, res: Response) => {
  try {
    const { identity, password } = req.body;
    if (!identity || !password)
      return res.status(400).json({ error: 'Identity and password required', code: 'INVALID_CREDENTIALS' });

    const cleanIdentity = identity.trim().toLowerCase();
    const user = await findUserByIdentity(cleanIdentity);
    if (!user)
      return res.status(401).json({ error: 'Invalid phone/email or password', code: 'AUTH_FAILED' });
    if (user.status === 'SUSPENDED')
      return res.status(403).json({ error: 'Account suspended. Please contact customer support.', code: 'ACCOUNT_SUSPENDED' });

    const isMatch = bcrypt.compareSync(password, user.password_hash);
    if (!isMatch)
      return res.status(401).json({ error: 'Invalid phone/email or password', code: 'AUTH_FAILED' });

    const profile = await findProfileByUserId(user.id);
    const boxCode = profile?.box_code || 'AB-8800';
    const token = signToken({ id: user.id, role: user.role, identity: user.identity, box_code: boxCode });

    res.json({
      message: 'Authentication successful',
      token,
      user: { id: user.id, identity: user.identity, fullName: profile?.full_name || 'Customer', boxCode, role: user.role },
    });
  } catch (error) {
    console.error('Sign in error:', error);
    res.status(500).json({ error: 'Internal server error during sign in', code: 'SERVER_ERROR' });
  }
});

// 3. Current User
router.get('/me', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const user = await findUserById(req.user!.id);
    if (!user) return res.status(404).json({ error: 'User not found', code: 'USER_NOT_FOUND' });
    const profile = await findProfileByUserId(user.id);
    const userData = {
      id: user.id, identity: user.identity, role: user.role, status: user.status,
      fullName: profile?.full_name || 'Customer', phone: profile?.phone || '',
      email: profile?.email || '', boxCode: profile?.box_code || '', avatarUrl: profile?.avatar_url || '',
    };
    res.json({ ...userData, user: userData });
  } catch (error) {
    res.status(500).json({ error: 'Server error', code: 'SERVER_ERROR' });
  }
});

// 4. Update Profile
router.put('/profile', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { fullName, phone, email, countryCode, avatarUrl } = req.body;
    const updated = await updateProfile(req.user!.id, {
      full_name: fullName, phone, email, country_code: countryCode, avatar_url: avatarUrl,
    });
    res.json({ message: 'Profile updated successfully', profile: updated });
  } catch (error) {
    res.status(500).json({ error: 'Server error', code: 'SERVER_ERROR' });
  }
});

// 5. Change Password
router.post('/change-password', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { currentPassword, newPassword } = req.body;
    if (!currentPassword || !newPassword)
      return res.status(400).json({ error: 'Current and new password required', code: 'INVALID_INPUT' });
    if (newPassword.length < 6)
      return res.status(400).json({ error: 'New password must be at least 6 characters', code: 'WEAK_PASSWORD' });

    const user = await findUserById(req.user!.id);
    if (!user) return res.status(404).json({ error: 'User not found', code: 'NOT_FOUND' });
    if (!bcrypt.compareSync(currentPassword, user.password_hash))
      return res.status(401).json({ error: 'Current password is incorrect', code: 'WRONG_PASSWORD' });

    await updateUserPassword(user.id, bcrypt.hashSync(newPassword, 10));
    res.json({ message: 'Password changed successfully', success: true });
  } catch (error) {
    res.status(500).json({ error: 'Server error', code: 'SERVER_ERROR' });
  }
});

// 6. Delete Account
router.delete('/account', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { password } = req.body;
    if (!password)
      return res.status(400).json({ error: 'Password confirmation required', code: 'INVALID_INPUT' });
    const user = await findUserById(req.user!.id);
    if (!user) return res.status(404).json({ error: 'User not found', code: 'NOT_FOUND' });
    if (!bcrypt.compareSync(password, user.password_hash))
      return res.status(401).json({ error: 'Password is incorrect', code: 'WRONG_PASSWORD' });
    await deleteUserAccount(user.id);
    res.json({ message: 'Account deleted successfully', success: true });
  } catch (error) {
    res.status(500).json({ error: 'Server error', code: 'SERVER_ERROR' });
  }
});

// 7. Forgot Password (placeholder — real implementation requires email service)
router.post('/forgot-password', (req: Request, res: Response) => {
  const { identity } = req.body;
  if (!identity) return res.status(400).json({ error: 'Identity required', code: 'MISSING_IDENTITY' });
  res.json({ message: 'If an account exists, password recovery instructions have been sent.', success: true });
});

export default router;
