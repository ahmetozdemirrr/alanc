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
- Precompiler optimizasyon
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
- **Sorumluluk**: Dört işlem ve değişken atamaları gibi işlemlerin düşük seviyede kod üretilmesini sağlayacak. LLVM, dilin arka ucunda çalışarak derleme ve optimizasyon yapacak.

### 4. **CMake**
- **Görevi**: Derleme sistemini yönetmek.
- **Sorumluluk**: Flex, Bison ve LLVM ile birlikte çalışarak projenin derleme aşamalarını yönetecek.

### 5. **Git**
- **Görevi**: Versiyon kontrolü.
- **Sorumluluk**: Proje dosyalarının sürüm takibini yapacak ve açık kaynak olarak paylaşımı yönetecek.

## Proje Aşamaları

### 1. **Dil Tasarımı**
   - Bu kısım zamanla geliştirilmeye devam edilecek.
   - Değişken atama ve işlem örnekleri:
     ```
     a = 5;
     b = 10;
     c = a + b;
     print(c);
     ```
   - Her işlem satır sonu noktasıyla (`;`) bitirilecek.

### 2. **Lexik Analiz (Flex ile)**
   - **Token Tanımları**: Değişken isimleri, sayılar ve işleçler için tokenler tanımlanacak.
   - Flex kullanılarak dilin girdi akışı anlamlı parçalara ayrılacak.

### 3. **Sözdizimi Analizi (Bison ile)**
   - **Sözdizimi Kuralları**: Dört temel işlem ve değişken atama kuralları Bison ile tanımlanacak.
   - Girdi, Bison tarafından dilin gramer kurallarına göre analiz edilecek ve doğru yapılarda işlenecek.

### 4. **Kod Üretimi (LLVM ile)**
   - **Kod Üretim Aşaması**: Bison tarafından analiz edilen girdi LLVM kullanılarak makine koduna dönüştürülecek.
   - **Optimizasyon**: Kodun daha verimli çalışması için LLVM'in optimizasyon özelliklerinden yararlanılacak.

### 5. **Derleme ve Yapılandırma (CMake ile)**
   - **CMake Kullanımı**: Flex, Bison ve LLVM araçlarını entegre ederek proje derlenecek.
   - Derleme işlemi sırasında tüm bağımlılıklar yönetilecek ve çalıştırılabilir bir dosya üretilecek.

### 6. **Versiyon Kontrol ve İşbirliği (Git ile)**
   - **Git Kullanımı**: Proje süresince değişiklikler versiyon kontrol sistemi Git ile takip edilecek.
   - Kod açık kaynak platformlarda (örneğin GitHub) paylaşılacak ve işbirliği sağlanacak.

## Yapılandırma ve Geliştirme Aşamaları

### 1. **Flex ve Bison Entegrasyonu**
   - Flex ile tokenler üretilecek ve Bison bu tokenlere göre dilin sözdizimini yönetecek.

### 2. **LLVM ile Kod Üretimi**
   - Kod üretimi ve optimizasyon için LLVM kullanılacak. Bu aşamada performans odaklı geliştirmeler yapılacak.

### 3. **CMake ile Derleme**
   - Tüm araçlar CMake kullanılarak birleştirilecek ve proje derlenecek.

### 4. **Git ile Versiyon Kontrolü**
   - Tüm değişiklikler ve kod versiyonları Git ile takip edilecek.
   - Proje GitHub gibi bir açık kaynak platformda yayınlanacak.
