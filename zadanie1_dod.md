## Weather App – Docker Multi-Arch Build (Zadanie dodatkowe)
**Cel zadania** <br>
Celem było zbudowanie kontenera zgodnego z OCI dla aplikacji pogodowej, opracowanej w ramach zadania obowiązkowego. Kontener miał być zgodny z platformami:
- linux/amd64
- linux/arm64
Budowa musiała spełniać następujące wymagania:
- wykorzystanie buildera docker-container poprzez docker buildx
- użycie BuildKit i frontend buildkit do klonowania publicznego repozytorium z GitHuba z wykorzystaniem mount=secret
- wykorzystanie cache (eksporter registry, backend registry, tryb max)
- potwierdzenie, że:
    - manifest zawiera obie platformy
    - cache został utworzony i jest wykorzystywany

## 1. Włączenie BuildKit i utworzenie buildera
```bash
docker buildx create --name multiarch-builder --use
```
![Image](https://github.com/user-attachments/assets/1bc4e481-0349-4404-afdf-1efebf3d9590)

**Potwierdzenie stworzenia buildera:**
```bash
docker buildx inspect --bootstrap
```
![Image](https://github.com/user-attachments/assets/0e9ef3f4-3212-49a5-b120-e5d7eadc89e9)

## 2. Budowanie obrazu na wiele platform z wykorzystaniem cache i mount secret
```bash
docker buildx build --platform linux/amd64,linux/arm64 --file Dockerfile_dod --tag adamdawi/weather-app:latest --push --build-arg BUILDKIT_INLINE_CACHE=1 --cache-to=type=registry,ref=adamdawi/weather-app:buildcache,mode=max --cache-from=type=registry,ref=adamdawi/weather-app:buildcache --secret id=GITHUB_TOKEN,src=my_token.txt .
```
![Image](https://github.com/user-attachments/assets/565920c9-af5e-4b5f-a24a-7f2a4d09d5de)

## 3. Potwierdzenie obecności manifestu dla wielu platform
Potwierdzenie, że manifest obrazu zawiera wpisy dla obu platform sprzętowych (linux/amd64 oraz linux/arm64):
```bash
docker buildx imagetools inspect adamdawi/weather-app:latest
```
![Image](https://github.com/user-attachments/assets/88a39931-69e3-4ae7-a163-20fd43397d11)

## 4. Sprawdzenie podatności w obrazie
```bash
docker scout cves --platform linux/amd64 adamdawi/weather-app:latest
```
![Image](https://github.com/user-attachments/assets/74561aa6-5274-45d6-af95-c7bf7f59d38a)

**Znaleziona podatność:**
- Pakiet: cross-spawn@7.0.3
- Poziom ryzyka: HIGH (7.5/10)
- CVE: CVE-2024-21538
- Opis: Inefficient Regular Expression Complexity
- Dotknięte wersje: >=7.0.0 i <7.0.5
- Poprawiona wersja: 7.0.5

## 5. Aktualizacja zależności i ponowne budowanie
Zmieniono `package.json`:
```json
"cross-spawn": "^7.0.5"
```

**Zmiana wersji cross-spawn w dependencies:**
<br>
![Image](https://github.com/user-attachments/assets/6c63e099-6e8c-49d2-8b6d-b09878c45766)

**Pełne ponowne budowanie bez użycia cache lokalnego:**
```bash
docker buildx build --platform linux/amd64,linux/arm64 --file Dockerfile_dod --tag adamdawi/weather-app:latest --push --build-arg BUILDKIT_INLINE_CACHE=1 --cache-to=type=registry,ref=adamdawi/weather-app:buildcache,mode=max --cache-from=type=registry,ref=adamdawi/weather-app:buildcache --no-cache --secret id=GITHUB_TOKEN,src=my_token.txt .
```
![Image](https://github.com/user-attachments/assets/f27a32d2-361d-463d-b5f5-911d728eae57)

## 6. Potwierdzenie użycia cache i publikacji obrazu w Docker Hub
Zrzuty ekranu potwierdzają, że podczas budowy obrazu wykorzystywany był cache zapisany wcześniej w rejestrze (`registry backend, mode=max`).
![Image](https://github.com/user-attachments/assets/164acf63-0658-4c5a-a5ad-b87282bbd567)
![Image](https://github.com/user-attachments/assets/08adc9de-3f4a-4960-9ce0-1716ae0bbe5d)
![Image](https://github.com/user-attachments/assets/9b6bafc8-ab50-441f-8630-ac9a61f1883f)