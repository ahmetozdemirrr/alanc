## 1. Bison'da Operatör Önceliği ve Bağlayıcılığı Nedir?
* **Operatör Önceliği:** Bir ifadede birden fazla operatör olduğunda, hangi operatörün önce uygulanacağını belirler.

* **Bağlayıcılık (Associativity):** Aynı önceliğe sahip operatörlerin soldan mı yoksa sağdan mı değerlendirileceğini belirler.

  

  **Örnek:**

* **Öncelik:** `*` çarpma operatörü, `+` toplama operatöründen daha yüksek önceliğe sahiptir. Yani `2 + 3 * 4` ifadesi `2 + (3 * 4)` olarak değerlendirilir.
* **Bağlayıcılık:** `-` çıkarma operatörü sol bağlayıcılıdır. Yani `10 - 5 - 2` ifadesi `(10 - 5) - 2` olarak değerlendirilir.



------

### **2. Bison'da Operatör Önceliği ve Bağlayıcılığını Tanımlama**

Bison'da operatör önceliklerini ve bağlayıcılıklarını tanımlamak için `%left`, `%right`, `%nonassoc` direktiflerini kullanırız.

#### **`%left`**

- **Anlamı:** Sol bağlayıcılı operatörleri tanımlar.
- **Kullanımı:** Aynı önceliğe sahip operatörlerin soldan sağa değerlendirilmesini sağlar.

#### **`%right`**

- **Anlamı:** Sağ bağlayıcılı operatörleri tanımlar.
- **Kullanımı:** Aynı önceliğe sahip operatörlerin sağdan sola değerlendirilmesini sağlar.

#### **`%nonassoc`**

- **Anlamı:** Bağlayıcılığı olmayan operatörleri tanımlar.
- **Kullanımı:** Aynı önceliğe sahip operatörlerin yan yana gelmesine izin vermez; hata verir.

#### **Tanımlama Sırası ve Öncelik**

- Bison'da operatörlerin öncelikleri, `%left`, `%right` ve `%nonassoc` direktiflerinin tanımlanma sırasına göre belirlenir.
- **Üstte Tanımlanan Operatörler:** Daha düşük önceliğe sahiptir.
- **Altta Tanımlanan Operatörler:** Daha yüksek önceliğe sahiptir.

**Örnek:**

```Yacc
%left '+' '-'
%left '*' '/'
%right UMINUS
```

- Burada:
  - `'+'` ve `'-'` operatörleri en düşük önceliğe sahiptir ve sol bağlayıcılıdır.
  - `'*'` ve `'/'` operatörleri daha yüksek önceliğe sahiptir ve sol bağlayıcılıdır.
  - `UMINUS` (unary minus) en yüksek önceliğe sahiptir ve sağ bağlayıcılıdır.



------

## **3. `%prec` Nedir ve Nasıl Kullanılır?**

#### **`%prec`'in Anlamı**

- **Açılımı:** "Precedence" yani "öncelik" demektir.
- **İşlevi:** Bir dilbilgisi kuralına, içinde geçen sembollerden farklı bir öncelik atamak için kullanılır.

#### **Neden Gerekli?**

- Bison, varsayılan olarak bir kuralın önceliğini, o kuraldaki **son terminal sembolün** önceliği olarak alır.
- Ancak bazı durumlarda bu varsayılan davranış istenmeyen sonuçlara yol açabilir. Özellikle unary (tekli) operatörler için.

#### **`%prec` Kullanımı**

- Bir dilbilgisi kuralının sonuna `%prec` ve ardından tanımladığınız bir sembol yazarak kullanılır.
- Bu sembol, önceden `%left`, `%right` veya `%nonassoc` ile tanımlanmış olmalıdır.

**Örnek:**

```Yacc
%right UMINUS

...

EXP:
      '-' EXP %prec UMINUS { /* Semantik aksiyon */ }
    | /* Diğer kurallar */
    ;

```

- Burada `'-' EXP` kuralına `%prec UMINUS` ile `UMINUS` önceliği atıyoruz.



## **4. Operatör Önceliği ve Bağlayıcılığını Uygulamalı Olarak Anlamak**

#### **Adım Adım Örnek**

Diyelim ki aşağıdaki ifadeleri ayrıştırmak istiyoruz:

1. `3 + 4 * 5`
2. `-3 + 5`
3. `3 - 4 - 5`

#### **Operatörleri Tanımlayalım**

```Yacc
%left '+' '-'
%left '*' '/'
%right UMINUS
```

- Öncelik Sırası (Düşükten Yükseğe):
  1. `'+'`, `'-'` (en düşük)
  2. `'*'`, `'/'`
  3. `UMINUS` (en yüksek)

#### **İfade 1: `3 + 4 * 5`**

- **Operatörler:** `'+'` ve `'*'`
- Önceliklere Göre Değerlendirme:
  - `'*'` operatörü daha yüksek önceliğe sahip.
  - Önce `4 * 5` hesaplanır, sonra `3 + (4 * 5)`.

#### **İfade 2: `-3 + 5`**

- **Operatörler:** `UMINUS` ve `'+'`
- Önceliklere Göre Değerlendirme:
  - `UMINUS` en yüksek önceliğe sahip.
  - Önce `-3` hesaplanır, sonra `(-3) + 5`.

#### **İfade 3: `3 - 4 - 5`**

- **Operatörler:** `'-'`, `'-'`
- Bağlayıcılığa Göre Değerlendirme:
  - `'-'` operatörü sol bağlayıcılı (`%left '-'`).
  - İfade `(3 - 4) - 5` olarak değerlendirilir.



## **5. `%prec` ile Özel Durumların Yönetimi**

#### **Unary Minus (Tekli Eksi) Örneği**

- **Sorun:** `'+'` ve `'-'` operatörleri hem unary (tekli) hem de binary (ikili) olarak kullanılabilir.
- **Varsayılan Davranış:** Bison, `'-' EXP` kuralının önceliğini `EXP`'nin son terminal sembolüne göre belirler, bu da istenmeyen bir öncelik seviyesine yol açabilir.
- **Çözüm:** `%prec` kullanarak unary minus operatörüne özel bir öncelik atamak.

**Uygulama:**

```Yacc
%left '+' '-'
%left '*' '/'
%right UMINUS

...

EXP:
      '-' EXP %prec UMINUS { $$ = -$2;     }
    | EXP '+' EXP          { $$ = $1 + $3; }
    | EXP '-' EXP          { $$ = $1 - $3; }
    | EXP '*' EXP          { $$ = $1 * $3; }
    | EXP '/' EXP          { $$ = $1 / $3; }
    | '(' EXP ')'          { $$ = $2;      }
    | NUMBER               { $$ = $1;      }
    ;
```



- Açıklama:
  - `'-' EXP %prec UMINUS`: Unary minus operatörüne `UMINUS` önceliğini atıyoruz.
  - Böylece `UMINUS` en yüksek önceliğe sahip olduğu için, unary minus operatörü diğer operatörlerden önce değerlendirilir.

#### **`%prec` ile Önceliğin Değiştirilmesi**

- **Varsayılan Öncelik:** Bir kuralın son terminal sembolünden alınır.
- **`%prec` Kullanımı:** Kuralın son terminal sembolü yerine belirttiğiniz sembolün önceliği kullanılır.



## **6. Tanımlama Sırası Neden Önemli?**

Operatörlerin önceliklerini ve bağlayıcılıklarını tanımlarken, bu tanımların sırası önemlidir çünkü Bison öncelikleri tanımlama sırasına göre belirler.

- **Üstte Tanımlanan Operatörler:** Daha düşük önceliğe sahiptir.
- **Altta Tanımlanan Operatörler:** Daha yüksek önceliğe sahiptir.

**Örnek:**

```Yacc
%left '+' '-'
%left '*' '/'
%right UMINUS
```

- Burada:
  - `'+'`, `'-'`: En düşük öncelik
  - `'*'`, `'/'`: Orta öncelik
  - `UMINUS`: En yüksek öncelik

**Eğer Sıra Değişirse:**

```Yacc
%right UMINUS
%left '*' '/'
%left '+' '-'
```



- Bu durumda:
  - `UMINUS`: En düşük öncelik
  - `'*'`, `'/'`: Orta öncelik
  - `'+'`, `'-'`: En yüksek öncelik
- **Sonuç:** İfadeler yanlış değerlendirilebilir.

**Not:** Bu nedenle, operatörleri tanımlarken sıralarına dikkat etmek önemlidir.



------


## **7. Bağlayıcılık (Associativity) Neden Önemli?**


Bağlayıcılık, aynı önceliğe sahip operatörlerin ifadede nasıl gruplandırılacağını belirler.

#### **Sol Bağlayıcılık (`%left`)**

- Operatörler soldan sağa değerlendirilir.
- **Örnek:** `10 - 5 - 2` ifadesi `(10 - 5) - 2` olarak değerlendirilir.

#### **Sağ Bağlayıcılık (`%right`)**

- Operatörler sağdan sola değerlendirilir.
- **Örnek:** `2 ^ 3 ^ 2` ifadesi `2 ^ (3 ^ 2)` olarak değerlendirilir (üs alma işlemi).

#### **Bağlayıcılığı Olmayan (`%nonassoc`)**

- Aynı öncelikte ve yan yana gelen operatörlere izin vermez, sözdizimi hatası verir.
- **Örnek:** `a < b < c` ifadesi mantıksızdır ve hata vermelidir.



### **8. Uygulama ve Özet**

- **Operatör Önceliği ve Bağlayıcılığı:** İfadelerin doğru şekilde değerlendirilmesi için kritiktir.
- **`%left`, `%right`, `%nonassoc`:** Operatörlerin öncelik ve bağlayıcılıklarını tanımlar.
- **`%prec`:** Bir kuralın önceliğini manuel olarak ayarlamak için kullanılır.
- **Tanımlama Sırası:** Operatörlerin önceliklerini belirler; alttaki tanımlar daha yüksek önceliğe sahiptir.
- **Bağlayıcılık:** Aynı öncelikteki operatörlerin ifadede nasıl gruplandırılacağını belirler.



### **9. Örnek Projeye Uygulama**

**Lexer (`lexer.l`):**

```Lex
%{
    #include "parser.tab.h"
%}

%%

"+"     { return '+'; }
"-"     { return '-'; }
"*"     { return '*'; }
"/"     { return '/'; }
"("     { return '('; }
")"     { return ')'; }
[0-9]+  {
    yylval = atoi(yytext);
    return NUMBER;
}
[ \t\n]+    { /* Boşlukları yoksay */ }
.       { yyerror("Geçersiz karakter"); }

%%
```

**Parser (`parser.y`):**

```Yacc
%{
    #include <stdio.h>
    #include <stdlib.h>
%}

%token NUMBER

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

input:
      /* boş */
    | input line
    ;

line:
      '\n'
    | expr '\n' { printf("Sonuç: %d\n", $1); }
    ;

expr:
      NUMBER
    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')' { $$ = $2; }
    ;

%%

int main(void) {
    printf("Bir ifade girin:\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Hata: %s\n", s);
}
```



**Açıklama:**

- Operatörlerin öncelikleri ve bağlayıcılıkları tanımlandı.
- Unary minus için `%prec UMINUS` kullanıldı.
- İfadeler doğru şekilde değerlendirilecek.



### **10. Sonuç**

Operatör öncelikleri ve bağlayıcılıkları, ifadelerin doğru şekilde değerlendirilmesi için hayati öneme sahiptir. Bison'da bu özellikleri doğru şekilde tanımlamak için:

- Operatörlerin öncelik ve bağlayıcılıklarını `%left`, `%right`, `%nonassoc` ile tanımlayın.
- Tanımlama sırasına dikkat edin; alttaki tanımlar daha yüksek önceliğe sahiptir.
- `%prec` kullanarak, dilbilgisi kurallarına özel öncelikler atayın.
- Bağlayıcılık ile aynı öncelikteki operatörlerin nasıl gruplandırılacağını belirleyin.

Bu şekilde, parser'ınız ifadeleri doğru şekilde ayrıştıracak ve değerlendirecektir.

