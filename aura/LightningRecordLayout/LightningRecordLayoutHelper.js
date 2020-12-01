/**
 * @Description Helper class for LightingRecordLayout component
 * @Author Eric Liang
 * @Date 2019/10/18 11:16
 * @Version 1.0
 **/

({
    setFieldNames: function (component) {
        let newFieldsArray = [];
        let fieldNamesString = component.get("v.fieldNamesString");
        if (fieldNamesString !== null && fieldNamesString !== undefined) {
            let fieldsArray = fieldNamesString.split(",");
            for (let field of fieldsArray) {
                field = field.trim();
                newFieldsArray.push(field);
            }
            component.set("v.fieldNames", newFieldsArray);
            console.log('***newFieldsArray ' + newFieldsArray);
        }
    }
});