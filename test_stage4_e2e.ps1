# ==============================================================================
# STAGE 4 COMPLETE AUTOMATED END-TO-END QA TEST SUITE
# Covers:
# 1. Canonical Futian Status Consistency & Validation
# 2. Real Database / Seeded Structure & Security
# 3. Customer Auth & Password Hashing Verification
# 4. Strict Customer Isolation (Customer A vs Customer B)
# 5. Admin Authorization (Rejection of Customer, Staff, Admin Roles)
# 6. Real End-to-End Flow: Admin Write -> DB -> API -> Customer Read
# 7. Futian Order Full Lifecycle & History Tracking
# 8. Shipping Rates Propagation
# 9. Real Notification Counts & Isolation
# 10. Audit Log Traceability
# ==============================================================================

$baseUrl = "http://localhost:5000/api/v1"
$passedCount = 0
$failedCount = 0

function Assert-Test($title, $condition, $details = "") {
    if ($condition) {
        Write-Host "  [PASS] $title" -ForegroundColor Green
        $script:passedCount++
    } else {
        Write-Host "  [FAIL] $title : $details" -ForegroundColor Red
        $script:failedCount++
    }
}

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  STARTING STAGE 4 FINAL END-TO-END QA TEST SUITE" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# ------------------------------------------------------------------------------
# 1. HEALTH & WAREHOUSE METADATA CHECK
# ------------------------------------------------------------------------------
Write-Host "`n[1/10] Warehouse Metadata & Health Check..." -ForegroundColor Yellow
try {
    $wh = Invoke-RestMethod -Uri "$baseUrl/my-china-box/warehouse-address" -Method GET
    Assert-Test "Warehouse endpoint responds with 200 OK" ($null -ne $wh)
    Assert-Test "Warehouse has English title" ($wh.titleEn -match "Guangzhou")
    Assert-Test "Warehouse has Arabic address" ($wh.addressAr.Length -gt 5)
} catch {
    Assert-Test "Warehouse endpoint responds with 200 OK" $false $_.Exception.Message
}

# ------------------------------------------------------------------------------
# 2. CUSTOMER AUTH TEST (Signup -> Hashed Password -> Signin -> JWT -> /me)
# ------------------------------------------------------------------------------
Write-Host "`n[2/10] Customer Auth & Password Hashing Test..." -ForegroundColor Yellow
$timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$testEmail = "qa_customer_$timestamp@test.com"
$testPassword = "QaSecurePassword123!"

try {
    # 2.1 Sign Up
    $signupBody = @{ identity = $testEmail; password = $testPassword } | ConvertTo-Json
    $signupRes = Invoke-RestMethod -Uri "$baseUrl/auth/china-box/signup" -Method POST -ContentType "application/json" -Body $signupBody
    Assert-Test "Sign up creates record and returns 201" ($null -ne $signupRes.token)
    Assert-Test "Sign up returns unique customer box code" ($signupRes.user.boxCode -match "^AB-")
    Assert-Test "Password hash is NOT exposed in signup response" ($null -eq $signupRes.user.password_hash)

    # 2.2 Sign In
    $signinBody = @{ identity = $testEmail; password = $testPassword } | ConvertTo-Json
    $signinRes = Invoke-RestMethod -Uri "$baseUrl/auth/china-box/signin" -Method POST -ContentType "application/json" -Body $signinBody
    $newCustomerToken = $signinRes.token
    Assert-Test "Sign in returns valid JWT token" ($newCustomerToken.Length -gt 20)

    # 2.3 /auth/me with Bearer token
    $meHeaders = @{ Authorization = "Bearer $newCustomerToken" }
    $meRes = Invoke-RestMethod -Uri "$baseUrl/auth/china-box/me" -Method GET -Headers $meHeaders
    Assert-Test "/auth/me returns authenticated customer identity" ($meRes.user.identity -eq $testEmail)
    Assert-Test "/auth/me returns role CUSTOMER" ($meRes.user.role -eq "CUSTOMER")
    Assert-Test "/auth/me does not expose password hash" ($null -eq $meRes.user.password_hash)

    # 2.4 Invalid Password rejection
    $wrongPassBody = @{ identity = $testEmail; password = "WrongPassword999!" } | ConvertTo-Json
    $wrongLoginFailed = $false
    try {
        Invoke-RestMethod -Uri "$baseUrl/auth/china-box/signin" -Method POST -ContentType "application/json" -Body $wrongPassBody
    } catch {
        $wrongLoginFailed = ($_.Exception.Response.StatusCode.value__ -eq 401)
    }
    Assert-Test "Invalid password rejected with 401 Unauthorized" $wrongLoginFailed
} catch {
    Assert-Test "Customer Auth test" $false $_.Exception.Message
}

# ------------------------------------------------------------------------------
# 3. AUTHENTICATE ALL ROLES FOR ISOLATION & PERMISSION TESTING
# ------------------------------------------------------------------------------
Write-Host "`n[3/10] Authenticating Demo Personas (Admin, Staff, Customer A, Customer B)..." -ForegroundColor Yellow

# Admin
$adminBody = @{ identity = "admin@ahmedbaba.com"; password = "AdminPassword123!" } | ConvertTo-Json
$adminRes = Invoke-RestMethod -Uri "$baseUrl/auth/china-box/signin" -Method POST -ContentType "application/json" -Body $adminBody
$adminToken = $adminRes.token
$adminHeaders = @{ Authorization = "Bearer $adminToken" }

# Staff
$staffBody = @{ identity = "staff@ahmedbaba.com"; password = "StaffPassword123!" } | ConvertTo-Json
$staffRes = Invoke-RestMethod -Uri "$baseUrl/auth/china-box/signin" -Method POST -ContentType "application/json" -Body $staffBody
$staffToken = $staffRes.token
$staffHeaders = @{ Authorization = "Bearer $staffToken" }

# Customer A
$custABody = @{ identity = "customer@ahmedbaba.com"; password = "CustomerPassword123!" } | ConvertTo-Json
$custARes = Invoke-RestMethod -Uri "$baseUrl/auth/china-box/signin" -Method POST -ContentType "application/json" -Body $custABody
$custAToken = $custARes.token
$custAHeaders = @{ Authorization = "Bearer $custAToken" }

# Customer B
$custBBody = @{ identity = "customer2@ahmedbaba.com"; password = "CustomerPassword123!" } | ConvertTo-Json
$custBRes = Invoke-RestMethod -Uri "$baseUrl/auth/china-box/signin" -Method POST -ContentType "application/json" -Body $custBBody
$custBToken = $custBRes.token
$custBHeaders = @{ Authorization = "Bearer $custBToken" }

Assert-Test "Admin authenticated (Role: ADMIN)" ($adminRes.user.role -eq "ADMIN")
Assert-Test "Staff authenticated (Role: STAFF)" ($staffRes.user.role -eq "STAFF")
Assert-Test "Customer A authenticated (Box: $($custARes.user.boxCode))" ($custARes.user.boxCode -eq "AB-8821")
Assert-Test "Customer B authenticated (Box: $($custBRes.user.boxCode))" ($custBRes.user.boxCode -eq "AB-9942")

# ------------------------------------------------------------------------------
# 4. CUSTOMER ISOLATION TEST (MANDATORY)
# ------------------------------------------------------------------------------
Write-Host "`n[4/10] Customer Isolation Test..." -ForegroundColor Yellow

# 4.1 Customer A packages query
$custAPkgsRaw = Invoke-RestMethod -Uri "$baseUrl/my-china-box/packages" -Method GET -Headers $custAHeaders
$custAPkgList = @($custAPkgsRaw)
$hasPkg999ForA = ($custAPkgList | Where-Object { $_.id -eq "pkg-999" })
Assert-Test "Customer A can see their own packages" ($custAPkgList.Count -ge 3)
Assert-Test "Customer A CANNOT see Customer B package (pkg-999)" ($null -eq $hasPkg999ForA)

# 4.2 Customer B packages query
$custBPkgsRaw = Invoke-RestMethod -Uri "$baseUrl/my-china-box/packages" -Method GET -Headers $custBHeaders
$custBPkgList = @($custBPkgsRaw)
$hasPkg999ForB = ($custBPkgList | Where-Object { $_.id -eq "pkg-999" })
Assert-Test "Customer B can see pkg-999 (BOX-999-ISOLATED)" ($null -ne $hasPkg999ForB)
Assert-Test "Customer B CANNOT see Customer A packages" ($custBPkgList.Count -eq 1)

# 4.3 Customer A Futian orders vs Customer B Futian orders
$custAOrders = Invoke-RestMethod -Uri "$baseUrl/futian/orders" -Method GET -Headers $custAHeaders
$custBOrders = Invoke-RestMethod -Uri "$baseUrl/futian/orders" -Method GET -Headers $custBHeaders
Assert-Test "Customer A sees 6 Futian orders" ($custAOrders.orders.Count -eq 6)
Assert-Test "Customer B sees 0 Futian orders (Strict Isolation)" ($custBOrders.orders.Count -eq 0)

# 4.4 Customer B attempting to access Customer A order directly by ID
$crossOrderAccessFailed = $false
try {
    Invoke-RestMethod -Uri "$baseUrl/futian/orders/%23AB-2505237" -Method GET -Headers $custBHeaders
} catch {
    $crossOrderAccessFailed = ($_.Exception.Response.StatusCode.value__ -eq 404 -or $_.Exception.Response.StatusCode.value__ -eq 403)
}
Assert-Test "Customer B cannot access Customer A order by ID (403/404)" $crossOrderAccessFailed

# ------------------------------------------------------------------------------
# 5. ADMIN AUTHORIZATION & PERMISSION REJECTION TEST
# ------------------------------------------------------------------------------
Write-Host "`n[5/10] Admin Authorization & Role Guard Test..." -ForegroundColor Yellow

# 5.1 Unauthenticated request to /admin/*
$unauthBlocked = $false
try {
    Invoke-RestMethod -Uri "$baseUrl/admin/overview-metrics" -Method GET
} catch {
    $unauthBlocked = ($_.Exception.Response.StatusCode.value__ -eq 401)
}
Assert-Test "Unauthenticated request to /admin rejected with 401" $unauthBlocked

# 5.2 Customer token trying to access /admin/*
$custBlockedFromAdmin = $false
try {
    Invoke-RestMethod -Uri "$baseUrl/admin/overview-metrics" -Method GET -Headers $custAHeaders
} catch {
    $custBlockedFromAdmin = ($_.Exception.Response.StatusCode.value__ -eq 403)
}
Assert-Test "Customer token rejected from /admin with 403 Forbidden" $custBlockedFromAdmin

# 5.3 Staff token allowed on overview
$staffAllowed = $false
try {
    $staffMetrics = Invoke-RestMethod -Uri "$baseUrl/admin/overview-metrics" -Method GET -Headers $staffHeaders
    $staffAllowed = ($null -ne $staffMetrics)
} catch {}
Assert-Test "Staff token authorized on admin overview" $staffAllowed

# 5.4 Admin token allowed on overview
$adminMetrics = Invoke-RestMethod -Uri "$baseUrl/admin/overview-metrics" -Method GET -Headers $adminHeaders
Assert-Test "Admin token has full authorized access" ($null -ne $adminMetrics.metrics)

# ------------------------------------------------------------------------------
# 6. CANONICAL FUTIAN STATUS VALIDATION
# ------------------------------------------------------------------------------
Write-Host "`n[6/10] Canonical Futian Status Consistency Test..." -ForegroundColor Yellow
$canonicalStatuses = @("UNDER_REVIEW", "PRICE_PENDING", "APPROVAL_PENDING", "PURCHASED", "SHIPPED", "ARRIVED", "CANCELLED")

# 6.1 Check metrics return the 7 canonical statuses + 1 all total
Assert-Test "Metrics include 'all' aggregate count" ($null -ne $adminMetrics.metrics.futian.total)
Assert-Test "Metrics include underReview count" ($null -ne $adminMetrics.metrics.futian.underReview)
Assert-Test "Metrics include pricePending count" ($null -ne $adminMetrics.metrics.futian.pricePending)
Assert-Test "Metrics include approvalPending count" ($null -ne $adminMetrics.metrics.futian.approvalPending)
Assert-Test "Metrics include purchased count" ($null -ne $adminMetrics.metrics.futian.purchased)
Assert-Test "Metrics include shipped count" ($null -ne $adminMetrics.metrics.futian.shipped)
Assert-Test "Metrics include arrived count" ($null -ne $adminMetrics.metrics.futian.arrived)
Assert-Test "Metrics include cancelled count" ($null -ne $adminMetrics.metrics.futian.cancelled)

# 6.2 Admin attempting invalid status update rejected
$invalidStatusRejected = $false
try {
    $badBody = @{ status = "INVALID_RANDOM_STATUS" } | ConvertTo-Json
    Invoke-RestMethod -Uri "$baseUrl/admin/futian/orders/fut-001/status" -Method PATCH -Headers $adminHeaders -ContentType "application/json" -Body $badBody
} catch {
    $invalidStatusRejected = ($_.Exception.Response.StatusCode.value__ -eq 400)
}
Assert-Test "Invalid Futian status rejected with 400 Bad Request" $invalidStatusRejected

# ------------------------------------------------------------------------------
# 7. ADMIN -> DATABASE -> CUSTOMER LIVE PROPAGATION: PACKAGES
# ------------------------------------------------------------------------------
Write-Host "`n[7/10] Flow 1: Admin Updates Package -> Customer Sees Updated Status..." -ForegroundColor Yellow

# Admin updates package status
$updatePkgBody = @{ status = "IN_WAREHOUSE" } | ConvertTo-Json
$updatePkgRes = Invoke-RestMethod -Uri "$baseUrl/admin/packages/pkg-001" -Method PATCH -Headers $adminHeaders -ContentType "application/json" -Body $updatePkgBody
Assert-Test "Admin successfully updates package pkg-001 status" ($updatePkgRes.package.status -eq "IN_WAREHOUSE")

# Customer A fetches their packages
$customerFreshPkgsRaw = Invoke-RestMethod -Uri "$baseUrl/my-china-box/packages" -Method GET -Headers $custAHeaders
$customerFreshPkgList = @($customerFreshPkgsRaw)
$freshPkg001 = ($customerFreshPkgList | Where-Object { $_.id -eq "pkg-001" })
Assert-Test "Customer A receives updated status in real-time" ($freshPkg001.status -eq "IN_WAREHOUSE")

# ------------------------------------------------------------------------------
# 8. ADMIN -> DATABASE -> CUSTOMER LIVE PROPAGATION: FUTIAN PRICING & LIFECYCLE
# ------------------------------------------------------------------------------
Write-Host "`n[8/10] Flow 2: Futian Pricing -> Customer Approval -> Status Lifecycle..." -ForegroundColor Yellow

# 8.1 Admin sets price on fut-001 (#AB-2505237)
$pricingBody = @{ unit_price_usd = 45.00; notes = "Stage 4 QA Verified Pricing" } | ConvertTo-Json
$pricingRes = Invoke-RestMethod -Uri "$baseUrl/admin/futian/orders/fut-001/pricing" -Method PATCH -Headers $adminHeaders -ContentType "application/json" -Body $pricingBody
Assert-Test "Admin sets price -> Order status advances to APPROVAL_PENDING" ($pricingRes.order.status -eq "APPROVAL_PENDING")
Assert-Test "Total price calculated accurately (45 * 2 = $90.00)" ($pricingRes.order.total_price_usd -eq 90.00)

# 8.2 Customer A fetches the order and sees updated pricing & timeline
$custOrderDetail = Invoke-RestMethod -Uri "$baseUrl/futian/orders/%23AB-2505237" -Method GET -Headers $custAHeaders
Assert-Test "Customer A sees unit price $45.00" ($custOrderDetail.unitPriceUsd -eq 45.00)
Assert-Test "Customer A sees total price $90.00" ($custOrderDetail.totalPriceUsd -eq 90.00)
Assert-Test "Customer A sees status 'APPROVAL_PENDING'" ($custOrderDetail.status -eq "APPROVAL_PENDING")
Assert-Test "Order history timeline recorded price determination" ($custOrderDetail.timeline.Count -ge 2)

# 8.3 Customer A approves the price
$approveRes = Invoke-RestMethod -Uri "$baseUrl/futian/orders/%23AB-2505237/approve" -Method PATCH -Headers $custAHeaders
Assert-Test "Customer A approves price -> Order status becomes PURCHASED" ($approveRes.order.status -eq "PURCHASED")

# 8.4 Verify order status history logged both transitions
$approvedDetail = Invoke-RestMethod -Uri "$baseUrl/futian/orders/%23AB-2505237" -Method GET -Headers $custAHeaders
$hasPurchasedHistory = ($approvedDetail.timeline | Where-Object { $_.toStatus -eq "PURCHASED" })
Assert-Test "Order history contains transition to PURCHASED" ($null -ne $hasPurchasedHistory)

# ------------------------------------------------------------------------------
# 9. ADMIN -> DATABASE -> CUSTOMER LIVE PROPAGATION: SHIPPING RATES
# ------------------------------------------------------------------------------
Write-Host "`n[9/10] Flow 3: Admin Changes Shipping Tariff -> Customer Gets New Rate..." -ForegroundColor Yellow

# Admin queries rates to get the real Air rate ID
$ratesRes = Invoke-RestMethod -Uri "$baseUrl/admin/shipping-rates" -Method GET -Headers $adminHeaders
$airRateObj = ($ratesRes.rates | Where-Object { $_.type -eq "AIR" })[0]
$airRateId = $airRateObj.id

# Admin updates Air rate to $9.50/kg
$newAirRateBody = @{ rate_per_kg = 9.50 } | ConvertTo-Json
$rateUpdateRes = Invoke-RestMethod -Uri "$baseUrl/admin/shipping-rates/$airRateId" -Method PATCH -Headers $adminHeaders -ContentType "application/json" -Body $newAirRateBody
Assert-Test "Admin updates Air cargo rate to $9.50/kg" ($rateUpdateRes.shippingMethod.rate_per_kg -eq 9.50)

# Customer fetches shipping options
$customerShippingRaw = Invoke-RestMethod -Uri "$baseUrl/my-china-box/shipping-options" -Method GET -Headers $custAHeaders
$shippingList = @($customerShippingRaw)
$airOption = ($shippingList | Where-Object { $_.id -eq $airRateId -or $_.type -eq "AIR" -or $_.type -eq "air" })[0]
Assert-Test "Customer app receives updated rate ($9.50/kg) from API/DB" ($airOption.ratePerKg -eq 9.50)

# ------------------------------------------------------------------------------
# 10. NOTIFICATIONS & AUDIT LOG TRACEABILITY
# ------------------------------------------------------------------------------
Write-Host "`n[10/10] Flow 4: Notifications & Admin Audit Logs..." -ForegroundColor Yellow

# 10.1 Customer notifications endpoint
$custANotifs = Invoke-RestMethod -Uri "$baseUrl/notifications" -Method GET -Headers $custAHeaders
Assert-Test "Customer A has notifications created by admin actions" ($custANotifs.notifications.Count -gt 0)
$unreadActual = ($custANotifs.notifications | Where-Object { $_.is_read -eq $false }).Count
Assert-Test "Customer A unread count matches calculation ($unreadActual)" ($custANotifs.unreadCount -eq $unreadActual)

# 10.2 Customer marks a notification as read
if ($custANotifs.notifications.Count -gt 0) {
    $firstNotifId = $custANotifs.notifications[0].id
    $readRes = Invoke-RestMethod -Uri "$baseUrl/notifications/$firstNotifId/read" -Method PATCH -Headers $custAHeaders
    Assert-Test "Customer marks notification as read" ($readRes.notification.is_read -eq $true)
}

# 10.3 Admin Audit Logs
$auditLogsRes = Invoke-RestMethod -Uri "$baseUrl/admin/audit-logs" -Method GET -Headers $adminHeaders
$auditList = if ($auditLogsRes.auditLogs) { $auditLogsRes.auditLogs } else { $auditLogsRes.logs }
Assert-Test "Admin audit logs exist for all recent write operations" ($auditList.Count -ge 3)
$recentAction = $auditList[0]
Assert-Test "Audit log contains admin identity ($($recentAction.admin_name))" ($null -ne $recentAction.admin_name)
Assert-Test "Audit log contains action ($($recentAction.action))" ($null -ne $recentAction.action)

# ------------------------------------------------------------------------------
# SUMMARY REPORT
# ------------------------------------------------------------------------------
Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "  TEST SUITE COMPLETED" -ForegroundColor Cyan
Write-Host "  PASSED: $passedCount" -ForegroundColor Green
$failColor = if ($failedCount -eq 0) { "Green" } else { "Red" }
Write-Host "  FAILED: $failedCount" -ForegroundColor $failColor
Write-Host "========================================================" -ForegroundColor Cyan

if ($failedCount -gt 0) {
    exit 1
} else {
    exit 0
}
