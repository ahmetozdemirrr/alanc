# Flex ve Bison: Yerleşik Değişkenler ve Fonksiyonlar

Bu belge, derleyici ve yorumlayıcı geliştirmek için sıklıkla kullanılan **Flex** (Lex) ve **Bison** (YACC) araçlarında yerleşik olarak kullanılan değişkenler ve fonksiyonlar hakkında detaylı bilgi sunmaktadır. Her bir değişken ve fonksiyonun ne işe yaradığı, nasıl kullanıldığı ve örnek kod parçacıkları ile açıklanmaktadır.

------

## Flex (Lex) Yerleşik Değişkenler ve Fonksiyonlar

Flex, metin tabanlı girdileri tarayarak token'lara dönüştüren bir lexer (lexical analyzer) oluşturucusudur. Aşağıda Flex'in sağladığı yerleşik değişkenler ve fonksiyonlar detaylı bir şekilde açıklanmaktadır.

### 1. `yylex()`

- **Tanım:** Flex tarafından üretilen ana lexer fonksiyonudur.
- **İşlevi:** Girdi akışını tarar ve her çağrıldığında bir sonraki token'i döndürür.
- **Kullanım:** Parser (Bison) tarafından çağrılır veya kendi yazdığınız kodda doğrudan kullanabilirsiniz.

**Örnek:**

```
int main(void) {
    int token;
    while ((token = yylex()) != 0) {
        printf("Token: %d\n", token);
    }
    return 0;
}
```

### 2. `yytext`

- **Tanım:** Son eşleşen token'in metnini içeren karakter dizisi işaretçisidir.
- **İşlevi:** Lexer tarafından tanınan token'in metnini tutar.
- **Kullanım:** Lexer kurallarınızda, token'in metnini almak için kullanabilirsiniz.

**Örnek:**

```
[a-zA-Z][a-zA-Z0-9_]* {
    printf("Tanımlayıcı: %s\n", yytext);
    return IDENTIFIER;
}
```

### 3. `yyleng`

- **Tanım:** Son eşleşen token'in uzunluğunu tutan tamsayı değişkendir.
- **İşlevi:** `yytext`'in uzunluğunu belirtir.
- **Kullanım:** Sütun numarasını güncellemek veya token uzunluğunu bilmek istediğinizde kullanabilirsiniz.

**Örnek:**

```
[ \t]+ {
    yycolumn += yyleng;
}
```

### 4. `yylineno`

- **Tanım:** Girdi akışındaki mevcut satır numarasını tutan tamsayı değişkendir.
- **İşlevi:** Satır numaralarını takip etmek için kullanılır.
- Kullanım:
  - `%option yylineno` seçeneği ile etkinleştirilir.
  - Hata mesajlarında veya konum bilgisinde satır numarasını almak için kullanılır.

**Örnek:**

```
%option yylineno

%%
\n { yylineno++; yycolumn = 1; }
```

### 5. `yyin`

- **Tanım:** Lexer'ın okuduğu girdi akışını belirten `FILE *` türünde bir işaretçidir.
- **İşlevi:** Lexer'ın hangi dosyadan okuma yapacağını belirler.
- Kullanım:
  - Varsayılan olarak `stdin`'dir.
  - Farklı bir dosyadan okuma yapmak için `yyin` değişkenini ayarlayabilirsiniz.

**Örnek:**

```
extern FILE *yyin;

int main(int argc, char *argv[]) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    }
    yylex();
    return 0;
}
```

### 6. `yyout`

- **Tanım:** Lexer'ın yazdığı çıktıyı belirten `FILE *` türünde bir işaretçidir.
- **İşlevi:** Lexer'ın çıktısını nereye yazacağını belirler.
- Kullanım:
  - Varsayılan olarak `stdout`'tur.
  - Çıktıyı farklı bir dosyaya yönlendirmek için `yyout` değişkenini ayarlayabilirsiniz.

**Örnek:**

```
extern FILE *yyout;

int main(void) {
    yyout = fopen("output.txt", "w");
    yylex();
    fclose(yyout);
    return 0;
}
```

### 7. `yywrap()`

- **Tanım:** Lexer'ın girdi akışının sonuna ulaştığında çağrılan fonksiyondur.
- **İşlevi:** Varsayılan olarak `1` döndürür ve lexer'ın sonlanmasını sağlar.
- Kullanım:
  - Çoklu dosya okuma veya özel davranışlar için `yywrap()` fonksiyonunu kendiniz tanımlayabilirsiniz.
  - `%option noyywrap` seçeneği ile `yywrap()` fonksiyonunun çağrılmasını engelleyebilirsiniz.

**Örnek:**

```
%option noyywrap

%%
/* Lexer kuralları */
%%

int yywrap(void) {
    return 0; /* Lexer sonlanmasın */
}
```

### 8. `yy_scan_string()`

- **Tanım:** Bir karakter dizisini lexer tarafından okunacak şekilde ayarlayan fonksiyondur.
- **İşlevi:** Lexer'ın girdi kaynağını bir string olarak ayarlar.
- **Kullanım:** String tabanlı girdi işlemek istediğinizde kullanılır.

**Örnek:**

```
#include <FlexLexer.h>

int main(void) {
    YY_BUFFER_STATE buffer = yy_scan_string("3 + 4 * 5");
    yylex();
    yy_delete_buffer(buffer);
    return 0;
}
```

### 9. `yy_delete_buffer()`

- **Tanım:** Lexer buffer'ını silmek için kullanılır.
- **İşlevi:** Kullanılmış olan buffer'ı temizler ve belleği serbest bırakır.
- **Kullanım:** `yy_scan_string()` ile oluşturulan buffer'ları temizlemek için kullanılır.

**Örnek:**

```
YY_BUFFER_STATE buffer = yy_scan_string("...");
// ...
yy_delete_buffer(buffer);
```

### 10. `YY_FLUSH_BUFFER`

- **Tanım:** Lexer'ın iç tamponunu temizlemek için kullanılan bir makrodur.
- **İşlevi:** Buffer'ı temizleyerek bir sonraki girdi için hazırlar.
- **Kullanım:** Girdi akışında değişiklik olduğunda veya buffer'ı sıfırlamak istediğinizde kullanılır.

**Örnek:**

```
YY_FLUSH_BUFFER;
```

### 11. `yyget_lineno()`, `yyset_lineno(int)`

- **Tanım:** `yylineno` değerini almak ve ayarlamak için kullanılan fonksiyonlardır.
- **İşlevi:** Satır numarasını okumak veya ayarlamak için kullanılır.
- **Kullanım:** Özellikle yeniden giriş (reentrancy) destekli lexer'larda kullanılır.

**Örnek:**

```
int line = yyget_lineno();
yyset_lineno(line + 1);
```

### 12. `yyget_text()`, `yyget_leng()`

- **Tanım:** `yytext` ve `yyleng` değerlerini almak için kullanılan fonksiyonlardır.
- **İşlevi:** Token metnini ve uzunluğunu okumak için kullanılır.
- **Kullanım:** Yeniden giriş destekli lexer'larda kullanılır.

**Örnek:**

```
char * text = yyget_text();
int length = yyget_leng();
```

------

## Bison (YACC) Yerleşik Değişkenler ve Fonksiyonlar

Bison, tanımladığınız dilbilgisine göre bir parser (ayrıştırıcı) oluşturan bir araçtır. Aşağıda Bison'un sağladığı yerleşik değişkenler ve fonksiyonlar açıklanmaktadır.

### 1. `yyparse()`

- **Tanım:** Bison tarafından üretilen ana parser fonksiyonudur.
- **İşlevi:** Lexer'dan token'ları alır ve dilbilgisine göre ayrıştırma yapar.
- **Kullanım:** Programınızın ana fonksiyonunda çağrılır ve parse işlemini başlatır.

**Örnek:**

```
int main(void) {
    if (yyparse() == 0) {
        printf("Parse başarılı!\n");
    } else {
        printf("Parse başarısız.\n");
    }
    return 0;
}
```

### 2. `yylval`

- **Tanım:** Lexer ile parser arasında değer aktarımı için kullanılan birleşim (union) yapısıdır.
- **İşlevi:** Token'ların değerlerini parser'a iletir.
- **Kullanım:** Lexer'da `yylval` değişkenine değer atayarak token değerlerini ayarlarsınız.

**Örnek:**

Lexer'da:

```
[0-9]+ {
    yylval.intval = atoi(yytext);
    return INTEGER;
}
```

Bison'da:

```
%union {
    int intval;
    /* Diğer tipler */
}

%token <intval> INTEGER
```

### 3. `yyerror(const char *s)`

- **Tanım:** Parser'da bir sözdizimi hatası oluştuğunda çağrılan fonksiyondur.
- **İşlevi:** Hata mesajlarını kullanıcıya iletmek için kullanılır.
- **Kullanım:** Kendi hata mesajlarınızı özelleştirmek için `yyerror` fonksiyonunu tanımlarsınız.

**Örnek:**

```
void yyerror(const char *s) {
    extern int yylineno;
    fprintf(stderr, "Hata: %s satır %d\n", s, yylineno);
}
```

### 4. `yylex()`

- **Tanım:** Lexer fonksiyonudur; Bison tarafından çağrılır.
- **İşlevi:** Lexer'dan bir sonraki token'i alır.
- **Kullanım:** Bison, otomatik olarak `yylex()` fonksiyonunu çağırır.

### 5. `$$` ve `$n`

- **Tanım:** Bison'da üretim kurallarının gövdelerinde kullanılan özel sembollerdir.
- İşlevi:
  - `$$`: Mevcut üretimin (kuralın) sonucunu temsil eder.
  - `$n`: Üretimdeki n'inci bileşenin değerini temsil eder.
- **Kullanım:** Üretimlerin sonucunu hesaplamak ve değerleri aktarmak için kullanılır.

**Örnek:**

```
expr: expr '+' expr {
    $$ = $1 + $3;
}
```

### 6. `@n` ve `@@`

- **Tanım:** Bileşenlerin konum bilgilerine (satır ve sütun numaraları) erişmek için kullanılır.
- **İşlevi:** Hata mesajlarında veya semantik işlemlerde konum bilgisini almak için kullanılır.
- Kullanım:
  - `%locations` direktifi ile etkinleştirilir.
  - `@n`: Üretimdeki n'inci bileşenin konumunu temsil eder.
  - `@@`: Mevcut üretimin (kuralın) konumunu temsil eder.

**Örnek:**

```
%define parse.error detailed
%locations

expr: expr '+' expr {
    printf("Toplama işlemi satır %d, sütun %d\n", @$.first_line, @$.first_column);
}
```

### 7. `YYABORT`, `YYACCEPT`, `YYERROR`

- **Tanım:** Parser'ın kontrol akışını yönetmek için kullanılan makrolardır.
- İşlevleri:
  - `YYABORT`: Ayrıştırmayı sonlandırır ve başarısızlıkla çıkar.
  - `YYACCEPT`: Ayrıştırmayı sonlandırır ve başarıyla çıkar.
  - `YYERROR`: Bir sözdizimi hatası oluşturur ve hata kurtarma işlemini başlatır.
- **Kullanım:** Kural gövdelerinde özel durumları yönetmek için kullanılır.

**Örnek:**

```
if_stmt: IF expr THEN stmt {
    if (!is_boolean($2)) {
        yyerror("IF ifadesinde boolean bekleniyor");
        YYERROR;
    }
}
```

### 8. `yynerrs`

- **Tanım:** Toplam oluşan sözdizimi hatası sayısını tutan tamsayı değişkendir.
- **İşlevi:** Parser'ın kaç hata ile karşılaştığını gösterir.
- **Kullanım:** Hata raporlama ve kontrol amaçlı kullanılabilir.

**Örnek:**

```
if (yynerrs > 0) {
    fprintf(stderr, "Toplam %d hata bulundu.\n", yynerrs);
}
```

### 9. `yychar`

- **Tanım:** Son okunan token'in numarasını tutan tamsayı değişkendir.
- **İşlevi:** Parser'ın hangi token'i işlediğini gösterir.
- **Kullanım:** Hata ayıklama ve özel durumlar için kullanılabilir.

**Örnek:**

```
if (yychar == YYEOF) {
    printf("Dosyanın sonuna ulaşıldı.\n");
}
```

### 10. `%token`, `%left`, `%right`, `%nonassoc`

- **Tanım:** Bison'da token'ları ve operatör önceliklerini tanımlamak için kullanılan direktiflerdir.
- İşlevleri:
  - `%token`: Token'ları tanımlar.
  - `%left`, `%right`, `%nonassoc`: Operatörlerin bağlayıcılığını ve önceliğini belirler.
- **Kullanım:** Dilbilginizin kurallarını ve operatör önceliklerini belirtmek için kullanılır.

**Örnek:**

```
%token PLUS MINUS TIMES DIVIDE
%left PLUS MINUS
%left TIMES DIVIDE
```

### 11. `%union`

- **Tanım:** `yylval` ve `$$` için kullanılacak veri tiplerini tanımlamak için kullanılır.
- **İşlevi:** Farklı veri tiplerini tek bir yapı altında toplar.
- **Kullanım:** Token ve üretimlerin değerlerini saklamak için kullanılır.

**Örnek:**

```
%union {
    int intval;
    float floatval;
    char *strval;
}
```

### 12. `%type`

- **Tanım:** Üretimlerin dönüş tiplerini belirtmek için kullanılır.
- **İşlevi:** Üretimlerin hangi tipte değer döndüreceğini belirler.
- **Kullanım:** `%union` ile tanımlanan tipleri üretimlere atamak için kullanılır.

**Örnek:**

```
%type <intval> expr term factor
```

### 13. `%start`

- **Tanım:** Başlangıç üretimini belirtmek için kullanılır.
- **İşlevi:** Parser'ın hangi üretimden başlaması gerektiğini belirler.
- **Kullanım:** Özellikle dilbilginizde birden fazla üst düzey üretim varsa kullanılır.

**Örnek:**

```
%start program
```

### 14. `%define` ve `%code`

- **Tanım:** Parser'ın davranışını ve kod üretimini özelleştirmek için kullanılır.
- **İşlevi:** Özelleştirilmiş kod parçacıkları eklemek ve Bison'un çalışma şeklini değiştirmek için kullanılır.
- **Kullanım:** Hata mesajlarını özelleştirmek, ek kod eklemek vb. için kullanılır.

**Örnek:**

```
%define parse.error verbose

%code requires {
    /* Header kodları */
}

%code {
    /* Ek kodlar */
}
```

------

## Özet

Bu belgede, Flex ve Bison araçlarında yerleşik olarak kullanılan değişkenler ve fonksiyonlar detaylı bir şekilde açıklanmıştır. Flex, metin girdilerini tarayarak token'lara dönüştürürken, Bison bu token'ları dilbilgisine göre ayrıştırır ve işlem yapar. Her iki araçta da, token değerlerini aktarmak, konum bilgilerini takip etmek ve hata yönetimi yapmak için özel değişkenler ve fonksiyonlar bulunmaktadır.

Bu değişkenleri ve fonksiyonları kullanarak:

- **Lexer ve parser arasında etkili bir iletişim kurabilir,**
- **Token'ların değerlerini ve konumlarını yönetebilir,**
- **Hata mesajlarını özelleştirebilir,**
- **Kod üretimi ve sembolik tablo yönetimi yapabilirsiniz.**

Geliştireceğiniz derleyici veya yorumlayıcı projelerinde bu bilgileri referans alarak daha etkili ve doğru bir şekilde çalışabilirsiniz.