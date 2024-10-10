# Token-Based Syntax Errors



This document lists the possible token-based syntax errors encountered during lexical analysis of the custom language. Each error includes a description, an example, and the expected behavior from the lexer. This is meant to serve as a reference and will be updated with more cases as the language evolves.

---



### 1. **Unrecognized Characters**

**Description**:  
If a character is encountered that is not defined in the language (e.g., invalid operators, punctuation, or special symbols), the lexer will report a syntax error.

**Example**:
```txt
?@variableX
```

**Expected Behavior**:  
The characters `?` and `@` are not recognized in the language. The lexer should throw an error.

**Error Message**:
```txt
SYNTAX ERROR: '?@' cannot be tokenized
```

All other characters are marked as syntax errors except these characters: +-/*()= \n\t

---



### 2. **Invalid Identifiers**

**Description**:  
Identifiers must start with a letter (A-Z, a-z) and can contain up to 32 alphanumeric characters or underscores (`_`). If an identifier starts with a number or contains invalid characters, a syntax error will occur.

**Example**:
```txt
123variable
```

**Expected Behavior**:  
Identifiers cannot start with numbers. Lexer should report an error for this malformed identifier.

**Error Message**:
```txt
SYNTAX ERROR: '123variable' cannot be tokenized
```

---



### 3. **Invalid Integer-Identifier Combination**

**Description**:  
Numbers (integers) must not be combined directly with characters, such as `3abc`. This will result in a syntax error since such tokens are neither valid integers nor identifiers.

**Example**:
```txt
3abc
```

**Expected Behavior**:  
The lexer should report an error when numbers are immediately followed by letters.

**Error Message**:
```txt
SYNTAX ERROR: '3abc' cannot be tokenized
```

---



### 4. **Unsupported Characters in Identifiers**

**Description**:  
Identifiers must contain only letters, digits, and underscores. Any special characters such as `@`, `$`, `#`, etc., in an identifier will lead to a syntax error.

**Example**:
```txt
var@name
```

**Expected Behavior**:  
Characters like `@` are not allowed in identifiers, so the lexer should flag this as an error.

**Error Message**:
```txt
SYNTAX ERROR: 'var@name' cannot be tokenized
```

---





## Future Updates

This document will be updated as new token-based syntax errors are identified during the development of the custom language. Ensure you regularly review the latest changes and test cases.
