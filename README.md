This is my implementation of the possibility of serialization and deserialization of json in the mql5 language

example:

```mql5
#include "node_modules/mql5-json/index.mqh"

void OnStart() {
    JSON::Object* json1 = new JSON::Object()
        .setProperty("number", 123456)
        .setProperty("string", "text")
        .setProperty("boolean", true)
        .setProperty("object", new JSON::Object()
            .setProperty("number", 123456)
            .setProperty("string", "text")
            .setProperty("boolean", true)
            .setProperty("array", new JSON::Array())
        )
        .setProperty("array", new JSON::Array()
            .add(true) // boolean
            .add(123456) // number
            .add("string") // string
            .add(new JSON::Object()
                .setProperty("number", 123456)
                .setProperty("string", "text")
            )
            .add(new JSON::Array()
                .add(true)
                .add(123456)
                .add("string")
            )
        );

    string exampleText = json1.toString();
    Print(exampleText);

    JSON::Object* json2 = new JSON::Object(exampleText);
    string objectKeys[];
    json2.getKeysToArray(objectKeys);

    if (
        json2.hasValue("array")
        && json2.isArray("array")
        && json2.getArray("array").getLength() > 4
        && json2.getArray("array").isBoolean(0)
        && json2.getArray("array").getBoolean(0) == true
        && json2.getArray("array").isObject(3)
        && json2.getArray("array").getObject(3).isString("string")
        && json2.getArray("array").getObject(3).getString("string") == "text"
        && json2.getArray("array").getObject(3).isNumber("number")
        && json2.getArray("array").getObject(3).getNumber("number") == double(123456)
    ) {
        Print(json2.toString());
        Print(json2.toString() == json1.toString());
    }

    delete json1;
    delete json2;
}
```
