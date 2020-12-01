/**
 * @Description Controller class for LightingRecordLayout component
 * @Author Eric Liang
 * @Date 2019/10/17 11:27
 * @Version 1.0
 **/

({
    doInit: function (component, event, helper) {
        let parentObjectName = component.get("v.parentObjectNameString");
        if (parentObjectName !== null && parentObjectName !== undefined) {
            //Show fields from parent object
            let action = component.get("c.getCrossObjectInfo");
            action.setParams({
                recordId: component.get("v.recordId"),
                parentObjectName: component.get("v.parentObjectNameString")
            })
            console.log('***recordId: ' + component.get("v.recordId"));
            console.log('***parentObjectNameString: ' + component.get("v.parentObjectNameString"));
            action.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    let returnValue = response.getReturnValue();
                    console.log('***setInfo return value: ' + JSON.stringify(returnValue));
                    component.set("v.objName", returnValue.objectName);
                    component.set("v.objId", returnValue.objectId);
                    component.set("v.recordTypeId", returnValue.recordTypeId);
                    component.set("v.showComponent",true);
                    helper.setFieldNames(component);
                    $A.get('e.force:refreshView').fire();
                }
            });
            $A.enqueueAction(action);
        } else {
            //Show fields from current object
            component.set("v.objName", component.get("v.recordId"));
            component.set("v.objId", component.get("v.sObjectName"));
            helper.setFieldNames(component);
        }
    }
});