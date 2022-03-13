/**
 * @description Utility class to check if an Apex trigger or a method can execute based on a custom permission assigned to the executing user.
 */
public with sharing class Bypass {

    private static final String BYPASS_ALLTRIGGERS = 'Bypass_AllTriggers';
    private static final String BYPASS_PREFIX = 'Bypass_%';
    public static final Set<String> TRIGGERS_REQUIRED_ONCE = new Set<String>(); // List of Apex triggers or methods that should run only once. Add any custom permission's developer name to the list at runtime.
    private static Set<String> triggersThatHasAlreadyRun = new Set<String>();
    private static Set<String> triggersToBypass = new Set<String>();

    static {
        // Retrieve custom permissions assigned to a user, no matter within which PermissionSet.
        // The DeveloperName of the custom permission must begin with the prefix defined in the 'BYPASS_PREFIX' constant.
        for (CustomPermission cp : [
            SELECT
                DeveloperName,
                (
                    SELECT Id
                    FROM SetupEntityAccessItems
                    WHERE
                        SetupEntityType = 'CustomPermission'
                        AND ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId())
                    LIMIT 1
                )
            FROM CustomPermission
            WHERE DeveloperName LIKE :BYPASS_PREFIX
            WITH SECURITY_ENFORCED
        ]) {
            if (cp.SetupEntityAccessItems != null && !cp.SetupEntityAccessItems.isEmpty()) {
                triggersToBypass.add(cp.DeveloperName);
            }
        }
    }

    /**
     * @description Checks if an Apex trigger or a method can execute based on a custom permission assigned to the executing user.
     * @param apexName The Apex trigger or method name.
     * @return A boolean telling if the code can execute or not.
     */
    public static Boolean canTrigger(String apexName) {
        if (TRIGGERS_REQUIRED_ONCE.contains(apexName)) {
            if (triggersThatHasAlreadyRun.contains(apexName)) {
                return false;
            }
            triggersThatHasAlreadyRun.add(apexName);
        }
        return (!triggersToBypass.contains(BYPASS_ALLTRIGGERS) && !triggersToBypass.contains(apexName));
    }

}