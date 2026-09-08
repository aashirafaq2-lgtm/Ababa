import { insertAdminAuditLog } from '../database/pg_service';
import { AuthUser } from './auth';

export async function recordAdminAudit(
  admin: AuthUser,
  action: string,
  entityType: string,
  entityId: string,
  oldValues: any,
  newValues: any,
  ipAddress?: string
): Promise<any> {
  const logEntry = await insertAdminAuditLog({
    admin_user_id: admin.id,
    admin_name: admin.identity,
    action,
    entity_type: entityType,
    entity_id: entityId,
    old_values: oldValues,
    new_values: newValues,
    ip_address: ipAddress,
  });

  console.log(`[Audit Log] [${action}] by ${admin.identity} on ${entityType}#${entityId}`);
  return logEntry;
}
