# Proje Yönerge Raporu

## Proje Tanımı
...

Proje tamamen **açık kaynak** araçlar kullanılarak gerçekleştirilecektir. Bu araçlar dilin lexik analizinden, parçacık üretimine, derlenmesine ve optimizasyonuna kadar tüm aşamalarda kullanılacaktır.

## Amaç ve önemli özellikler
- Basit ve hızlı bir dil modeli.
- Statik tipleme, fonksiyonel ve logic özellikler.
- Türler açısından sadelik
- Belleğe erişimli
- Katı ve sade built-in işlevler
- Optimizasyon odaklı
- Derlenebilir bir yapı kurmak ve bu süreci açık kaynak araçlarla yürütmek.
- Proje aşamalarını yönetmek ve açık kaynak platformlarda paylaşmak.

## Kullanılacak Araçlar

### 1. **Flex**
- **Görevi**: Lexik analiz yaparak kaynak kodu tokenlere ayırmak.
- **Sorumluluk**: Dilin girdisini (örneğin, değişken isimleri, sayılar ve işleçler) ayrıştırarak anlamlı parçalara ayıracak.

### 2. **Bison**
- **Görevi**: Parçacık (parser) üretmek.
- **Sorumluluk**: Flex tarafından üretilen tokenlere göre dilin sözdizimini oluşturacak.

### 3. **LLVM**
- **Görevi**: Dilin makine koduna derlenmesi ve optimize edilmesi.
- **Sorumluluk**: Düşük seviyede kod üretilmesini sağlayacak. LLVM, dilin arka ucunda çalışarak derleme ve optimizasyon yapacak.

### 4. **CMake**
- **Görevi**: Derleme sistemini yönetmek.
- **Sorumluluk**: Flex, Bison ve LLVM ile birlikte çalışarak projenin derleme aşamalarını yönetecek.

### 5. **Git**
- **Görevi**: Versiyon kontrolü.
- **Sorumluluk**: Proje dosyalarının sürüm takibini yapacak ve açık kaynak olarak paylaşımı yönetecek.

Örnek bir kod:

```
include standart.ALan

function foo(int a, float b)
{
    return (a * (b * 3));
}

procedure poo()
{
    bool b1 = true;
    bool b2 = false;

    if (b1 == b2)
    {
        b1 -> b2;
    }
    
    else
    {
        return;
    }

    print(Procedure end!);
}

procedure main()
{
    int array[] = {2, 3, 4};

    poo(foo());

    input(Enter a number:);
    
    return EXIT_SUCCESS;
}

# This is a comment and this is a expression ; x = y + 5 (but in a comment line)
```
