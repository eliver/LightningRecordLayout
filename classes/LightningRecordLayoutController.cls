/**
 * @Description Back_end controller class for LightingRecordLayout component
 * @Author Eric Liang
 * @Date 2019/10/17 11:26
 * @Version 1.0
 **/

public with sharing class LightningRecordLayoutController {
    public class RelatedObjectInfo {
        @AuraEnabled public String objectId { get; set; }
        @AuraEnabled public String objectName { get; set; }
        @AuraEnabled public String recordTypeId { get; set; }
    }

    @AuraEnabled
    public static RelatedObjectInfo getCrossObjectInfo(String recordId, String parentObjectName) {
        System.debug('***RecordsLayoutController getCrossObjectInfo recordId ' + recordId);
        System.debug('***RecordsLayoutController getCrossObjectInfo parentObjectName ' + parentObjectName);
        RelatedObjectInfo objInfo = new RelatedObjectInfo();
        String currentObjectName = Id.valueOf(recordId).getSobjectType().getDescribe().getName();
        if (String.isEmpty(parentObjectName) || parentObjectName.equalsIgnoreCase('undefined')) {
            objInfo.objectId = recordId;
            objInfo.objectName = currentObjectName;
            objInfo.recordTypeId = getRecordTypeId(objInfo.objectId);
        } else {
            List<SObject> sObjects = new Query(currentObjectName).selectField(parentObjectName).byId(recordId).run();
            System.debug('***RecordsLayoutController retrieve sObjects' + sObjects);
            if (sObjects.isEmpty()) {
                return objInfo;
            }
            objInfo.objectId = String.valueOf(getParentSObjectValue(sObjects.get(0), parentObjectName));
            objInfo.objectName = Id.valueOf(objInfo.objectId).getSobjectType().getDescribe().getName();
            objInfo.recordTypeId = getRecordTypeId(objInfo.objectId);
        }
        System.debug('***RecordsLayoutController retrieve ' + objInfo);
        return objInfo;
    }

    public static Object getParentSObjectValue(SObject sObj, String parentObjectName) {
        if (parentObjectName.split('\\.').size() > 1) {
            String parentSObjString = parentObjectName.split('\\.').get(0);
            sObj = sObj.getSObject(parentSObjString);
            return getParentSObjectValue(sObj, parentObjectName.removeStart(parentSObjString + '.'));
        } else {
            return sObj.get(parentObjectName);
        }
    }

    public static String getRecordTypeId(String sObjectId) {
        String currentSObjectName = Id.valueOf(sObjectId).getSobjectType().getDescribe().getName();
        if (new Query('RecordType').addConditionEq('SobjectType', currentSObjectName).run().isEmpty()) {
            return '';
        }
        return String.valueOf(new Query(currentSObjectName).selectField('RecordTypeId').byId(sObjectId).fetch().get('RecordTypeId'));
    }
}