"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.recordAdminAudit = recordAdminAudit;
const pg_service_1 = require("../database/pg_service");
async function recordAdminAudit(admin, action, entityType, entityId, oldValues, newValues, ipAddress) {
    const logEntry = await (0, pg_service_1.insertAdminAuditLog)({
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
