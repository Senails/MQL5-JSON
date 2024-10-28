class JSON {
public:
    JSON() {
        ArrayResize(this.jsonValueItemsArray, 0, 10);
    };
    JSON(string &json) {
        ArrayResize(this.jsonValueItemsArray, 0, 10);
        int parceJsonCharCounter = 0;
        bool isSuccess = this._parseJSON(json, parceJsonCharCounter);
        if (!isSuccess) this._clearResources();
    };

    JSON* setProperty(string key, string value)             { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, int value)                { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, long value)               { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, double value)             { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, bool value)               { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, JSON* value)              { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, string &value[])          { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, int &value[])             { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, long &value[])            { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, double &value[])          { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, bool &value[])            { return this._setProperty(key, new JsonValueItem(key, value)); }
    JSON* setProperty(string key, JSON* &value[])           { return this._setProperty(key, new JsonValueItem(key, value)); }

    bool isBoolean(string key) const                        { return this._getPropertyType(key) == JSONBoolType; }
    bool isNumber(string key) const                         { return this._getPropertyType(key) == JSONNumberType; }
    bool isString(string key) const                         { return this._getPropertyType(key) == JSONStringType; }
    bool isObject(string key) const                         { return this._getPropertyType(key) == JSONObjetType; }
    bool isArray(string key) const                          { return this._getPropertyType(key) == JSONArrayType; }
    bool isBooleanArray(string key, int index = 0) const    { return this._getArrayPropertyType(key, index) == JSONBoolType; }
    bool isNumberArray(string key, int index = 0) const     { return this._getArrayPropertyType(key, index) == JSONNumberType; }
    bool isStringArray(string key, int index = 0) const     { return this._getArrayPropertyType(key, index) == JSONStringType; }
    bool isObjectArray(string key, int index = 0) const     { return this._getArrayPropertyType(key, index) == JSONObjetType; }

    string getString(string key) const {
       const JsonValueItem* item = this._getProperty(key);
       if (item == NULL || item.valueType != JSONStringType) return "";
       return item.stringValue;
    }
    double getNumber(string key) const {
       const JsonValueItem* item = this._getProperty(key);
       if (item == NULL || item.valueType != JSONNumberType) return 0.0;
       return item.doubleValue;
    }
    bool getBoolean(string key) const {
       const JsonValueItem* item = this._getProperty(key);
       if (item == NULL || item.valueType != JSONBoolType) return false;
       return item.booleanValue;
    }
    JSON* getObject(string key) const {
       const JsonValueItem* item = this._getProperty(key);
       if (item == NULL || item.valueType != JSONObjetType) return NULL;
       return item.objectValue;
    }

    int getArrayLenght(string key) const {
        const JsonValueItem* item = this._getProperty(key);
        if (item == NULL || item.valueType != JSONArrayType) return 0;
        return item.arrayLenght;
    }

    string getStringFromArray(string key, int index) const {
       const JsonValueItem* item = this._getPropertyFromArray(key, index);
       if (item == NULL || item.valueType != JSONStringType) return "";
       return item.stringValue;
    }
    double getNumberFromArray(string key, int index) const {
       const JsonValueItem* item = this._getPropertyFromArray(key, index);
       if (item == NULL || item.valueType != JSONNumberType) return 0.0;
       return item.doubleValue;
    }
    bool getBooleanFromArray(string key, int index) const {
       const JsonValueItem* item = this._getPropertyFromArray(key, index);
       if (item == NULL || item.valueType != JSONBoolType) return false;
       return item.booleanValue;
    }
    JSON* getObjectFromArray(string key, int index) const {
       const JsonValueItem* item = this._getPropertyFromArray(key, index);
       if (item == NULL || item.valueType != JSONObjetType) return NULL;
       return item.objectValue;
    }

    string toString() const {
        int arraySize = ArraySize(this.jsonValueItemsArray);
        string result = "";

        for (int i = 0; i < arraySize; i++) {
            const JsonValueItem* item = this.jsonValueItemsArray[i];
            result += "\""+ item.key +"\": " + item.toString() + (i < arraySize -1 ? "," : "");
        }

        return "{" + result + "}";
    }

    ~JSON() {
        this._clearResources();
    }
private:
    class JsonValueItem;
    enum JSONValueItemTypes { JSONStringType, JSONNumberType, JSONBoolType, JSONObjetType, JSONArrayType, JSONUndefinedType };

    const JsonValueItem* jsonValueItemsArray[];

    void _JSON(const string &json) {
        ArrayResize(this.jsonValueItemsArray, 0, 10);
        int parceJsonCharCounter = 0;
        bool isSuccess = this._parseJSON(json, parceJsonCharCounter);
        if (!isSuccess) this._clearResources();
    }

    JSON* _setProperty(string key, const JsonValueItem* valueItem) {
        int arraySize = ArraySize(this.jsonValueItemsArray);

        for (int i = 0; i < arraySize; i++) {
            if (this.jsonValueItemsArray[i].key == key) {
                delete this.jsonValueItemsArray[i];
                this.jsonValueItemsArray[i] = valueItem;
                return &this;
            }
        }

        ArrayResize(this.jsonValueItemsArray, arraySize + 1, 10);
        this.jsonValueItemsArray[arraySize] = valueItem;
        return &this;
    }

    const JsonValueItem* _getProperty(string key) const {
        for (int i = 0; i < ArraySize(this.jsonValueItemsArray); i++) {
            if (this.jsonValueItemsArray[i].key == key) {
                return this.jsonValueItemsArray[i];
            }
        }
        return NULL;
    }
    const JsonValueItem* _getPropertyFromArray(string key, int index) const {
        const JsonValueItem* item = this._getProperty(key);
        if (item == NULL || item.valueType != JSONArrayType || index >= item.arrayLenght) return NULL;
        return item.arrayValue[index];
    }
    JSONValueItemTypes _getPropertyType(string key) const {
        for (int i = 0; i < ArraySize(this.jsonValueItemsArray); i++) {
            if (this.jsonValueItemsArray[i].key == key) {
                return this.jsonValueItemsArray[i].valueType;
            }
        }
        return JSONUndefinedType;
    }
    JSONValueItemTypes _getArrayPropertyType(string key, int index) const {
        for (int i = 0; i < ArraySize(this.jsonValueItemsArray); i++) {
            if (this.jsonValueItemsArray[i].key == key) {
                const JsonValueItem* item = this.jsonValueItemsArray[i];
                return item.valueType == JSONArrayType && item.arrayLenght > index
                    ? item.arrayValue[0].valueType
                    : JSONUndefinedType;
            }
        }
        return JSONUndefinedType;
    }
    
    bool _parseJSON(const string &json, int &i) {
        int len = StringLen(json);
        bool isSuccess = true;

        this._skipWhitespace(json, i);
        while (i < len && json[i++] != '{'); // Пропустить начальный символ '{'
        this._skipWhitespace(json, i);

        while (i < len) {
            this._skipWhitespace(json, i);

            string key = this._parseKey(json, i, isSuccess);
            if (!isSuccess) return false;

            this._skipWhitespace(json, i);
            if (json[i++] != ':') return false; // Ожидаем ':' после ключа
            this._skipWhitespace(json, i);

            if (this._isDigit(json[i]) || json[i] == '-') {
                this.setProperty(key, this._parseNumber(json, i, isSuccess));
            } else if (json[i] == 'n' || json[i] == 'N') {
                this.setProperty(key, this._parseNull(json, i, isSuccess));
            } else if (json[i] == 't' || json[i] == 'f') {
                this.setProperty(key, this._parseBoolean(json, i, isSuccess));
            } else if (json[i] == '"') {
                this.setProperty(key, this._parseString(json, i, isSuccess));
            } else if (json[i] == '{') {
                this.setProperty(key, this._parseObject(json, i, isSuccess));
            } else if (json[i] == '[') {
                this._setProperty(key, this._parseArray(json, i, isSuccess, key));
            }
            if (!isSuccess) break;

            this._skipWhitespace(json, i);
            if (json[i] == ',') { // Проверяем, есть ли следующая запятая
                i++;
                continue;
            } else if (json[i] == '}') {
                i++;
                break; // если конец строки то мы закончили 
            } else {
                isSuccess = false; // Если не закрывающая фигурная скобка, это ошибка
            }
        }

        return isSuccess;
    }
    bool _isDigit(ushort ch) const {
        return (ch >= '0' && ch <= '9');
    }
    void _skipWhitespace(const string &json, int &i) const {
        while (i < StringLen(json) && (json[i] == ' ' || json[i] == '\n' || json[i] == '\r' || json[i] == '\t')) i++;
    }
    string _parseKey(const string &json, int &i, bool &isSuccess) const {
        if (i < StringLen(json) && json[i] == '"') { // Проверка на наличие открывающей кавычки
            i++;  // Пропустить открывающую кавычку
            string key = "";

            // Считываем символы до закрывающей кавычки
            while (i < StringLen(json) && json[i] != '"') key += ShortToString(json[i++]);
            if (i < StringLen(json) && json[i] == '"') { // Проверка закрывающей кавычки
                i++;  // Пропустить закрывающую кавычку
                return key;
            }
        }

        isSuccess = false; // Если не удалось найти ключ
        return "";
    }
    double _parseNumber(const string &json, int &i, bool &isSuccess) const {
        string numberStr = "";
        bool isNegative = false;

        if (json[i] == '-') { // Проверка на отрицательное значение
            isNegative = true;
            i++;
        }

        while (i < StringLen(json) && this._isDigit(json[i])) { // Чтение целой части числа
            numberStr += ShortToString(json[i++]);
        }

        if (i < StringLen(json) && json[i] == '.') { // Чтение дробной части, если есть
            numberStr += ShortToString(json[i++]); // Добавить точку
            while (i < StringLen(json) && this._isDigit(json[i])) {
                numberStr += ShortToString(json[i++]);
            }
        }

        if (StringLen(numberStr) > 0) { // Конвертация строки в число
            double result = StringToDouble(numberStr);
            return isNegative ? -result : result;
        }

        isSuccess = false;
        return 0.0;
    }
    string _parseString(const string &json, int &i, bool &isSuccess) const {
        string result = "";
        i++; // Пропускаем открывающую кавычку

        while (i < StringLen(json)) {
            if (json[i] == '"') { // Если встречаем закрывающую кавычку
                i++; // Пропускаем закрывающую кавычку
                return result; // Возвращаем собранную строку
            } else if (json[i] == '\\') { // Проверяем на escape-последовательность
                i++; // Пропускаем символ '\'
                if (i < StringLen(json)) {
                    switch (json[i]) {
                        case 'n': result += "\n"; break;
                        case 't': result += "\t"; break;
                        case 'r': result += "\r"; break;
                        case '"': result += "\""; break;
                        case '\\': result += "\\"; break;
                        default: // Игнорируем неизвестные escape-последовательности
                            isSuccess = false;
                            return "";
                    }
                }
            } else {
                result += ShortToString(json[i]); // Добавляем обычный символ в строку
            }
            
            i++; // Переходим к следующему символу
        }

        // Если мы достигли конца строки, и не нашли закрывающую кавычку
        isSuccess = false;
        return "";
    }
    bool _parseBoolean(const string &json, int &i, bool &isSuccess) const {
        // Проверяем, соответствует ли подстрока "true" или "false" в любом регистре
        if (StringLen(json) >= i + 4) {
            string substringTrue = StringSubstr(json, i, 4);
            StringToLower(substringTrue);
            if (substringTrue == "true") {
                i += 4; // Пропустить "true"
                return true; // Успешно разобрано
            }
        }
        if (StringLen(json) >= i + 5) {
            string substringFalse = StringSubstr(json, i, 5);
            StringToLower(substringFalse);
            if (substringFalse == "false") {
                i += 5; // Пропустить "false"
                return false; // Успешно разобрано
            }
        }
        isSuccess = false; // Не соответствует "true" или "false"
        return false;
    }
    string _parseNull(const string &json, int &i, bool &isSuccess) const {
        // Проверяем, соответствует ли подстрока "null" в любом регистре
        if (StringLen(json) >= i + 4) {
            string substring = StringSubstr(json, i, 4);
            StringToLower(substring);

            if (substring == "null") {
                i += 4; // Пропустить "null"
                return "null"; // Успешно разобрано
            }
        }
        isSuccess = false; // Не соответствует "true" или "false"
        return "";
    }
    JSON* _parseObject(const string &json, int &i, bool &isSuccess) const {
        JSON* childObject = new JSON();
        isSuccess = childObject._parseJSON(json, i);
        return childObject;
    }
    JsonValueItem* _parseArray(const string &json, int &i, bool &isSuccess, string key) const {
        JsonValueItem* childElements[];
        ArrayResize(childElements, 0, 20);
        int itemCounter = 0;
        i++; // пропускам '['
    
        while (i < StringLen(json)) {
            this._skipWhitespace(json, i);

            // Распознаем тип элемента массива
            if (this._isDigit(json[i]) || json[i] == '-') {
                ArrayResize(childElements, itemCounter + 1, 20);
                childElements[itemCounter++] = new JsonValueItem("", this._parseNumber(json, i, isSuccess));
            } else if (json[i] == '"') {
                ArrayResize(childElements, itemCounter + 1, 20);
                childElements[itemCounter++] = new JsonValueItem("", this._parseString(json, i, isSuccess));
            } else if (json[i] == 'n' || json[i] == 'N') {
                ArrayResize(childElements, itemCounter + 1, 20);
                childElements[itemCounter++] = new JsonValueItem("", this._parseNull(json, i, isSuccess));
            } else if (json[i] == 't' || json[i] == 'f') {
                ArrayResize(childElements, itemCounter + 1, 20);
                childElements[itemCounter++] = new JsonValueItem("", this._parseBoolean(json, i, isSuccess));
            } else if (json[i] == '{') {
                ArrayResize(childElements, itemCounter + 1, 20);
                childElements[itemCounter++] = new JsonValueItem("", this._parseObject(json, i, isSuccess));
            }
            if (!isSuccess) break;

            this._skipWhitespace(json, i);
            if (json[i] == ',') {
                i++; // Пропускаем запятую
            } else if (json[i] == ']') {
                i++;
                break; // Конец массива
            } else {
                isSuccess = false;
                break;
            }
        }
        
        return new JsonValueItem(key, childElements);
    }

    void _clearResources() {
        for (int i = 0; i < ArraySize(this.jsonValueItemsArray); i++) delete this.jsonValueItemsArray[i];
        ArrayResize(this.jsonValueItemsArray, 0);
    }

    class JsonValueItem {
        public:
            string key;
            JSONValueItemTypes valueType;

            string stringValue;
            double doubleValue;
            bool booleanValue;
            JSON* objectValue;

            int arrayLenght;
            JsonValueItem* arrayValue[];

            JsonValueItem(string k, string value): key(k), valueType(JSONStringType), stringValue(value) {};
            JsonValueItem(string k, int value): key(k), valueType(JSONNumberType), doubleValue(double(value)) {};
            JsonValueItem(string k, long value): key(k), valueType(JSONNumberType), doubleValue(double(value)) {};
            JsonValueItem(string k, double value): key(k), valueType(JSONNumberType), doubleValue(value) {};
            JsonValueItem(string k, bool value): key(k), valueType(JSONBoolType), booleanValue(value) {};
            JsonValueItem(string k, JSON* value): key(k), valueType(JSONObjetType), objectValue(value) {};
            JsonValueItem(string k, JsonValueItem* &value[]): key(k), valueType(JSONArrayType), arrayLenght(ArraySize(value)) {
                ArrayResize(this.arrayValue, this.arrayLenght);
                for (int i = 0; i < this.arrayLenght; i++) {
                    this.arrayValue[i] = value[i];
                }
            }
            template <typename T>
            JsonValueItem(string k, T &value[]): key(k), valueType(JSONArrayType), arrayLenght(ArraySize(value)) {
                ArrayResize(this.arrayValue, this.arrayLenght);
                for (int i = 0; i < this.arrayLenght; i++) {
                    this.arrayValue[i] = new JsonValueItem(key, value[i]);
                }
            }

            string toString() const {
                if (this.valueType == JSONBoolType) return string(this.booleanValue);
                if (this.valueType == JSONNumberType) return string(this.doubleValue);
                if (this.valueType == JSONStringType) {
                    string copy = this.stringValue;
                    StringReplace(copy, "\"","\\\"");
                    return "\"" + copy + "\"";
                };
                if (this.valueType == JSONObjetType) return this.objectValue.toString();

                string result = "";
                for (int i = 0; i < this.arrayLenght; i++) {
                    result += this.arrayValue[i].toString() + (i < this.arrayLenght - 1 ? ", " : "");
                }
                return "[" + result + "]";
            }

            ~JsonValueItem() {
                if (this.valueType == JSONObjetType) delete this.objectValue;
                if (this.valueType == JSONArrayType) {
                    for (int i = 0; i < ArraySize(this.arrayValue); i++) delete this.arrayValue[i];
                }
            }
    };
};
