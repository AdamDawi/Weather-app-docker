## 1. Opracowanie aplikacji
W celu realizacji powyższych funkcji, użyta została aplikacja napisana w języku **JavaScript** z wykorzystaniem frameworka **Express**. Aplikacja uruchamiana jest na porcie TCP (domyślnie 3000), w logach aplikacji znajdują się informacje o czasie uruchomienia, autorze oraz porcie. Używa również zewnętrznego API Open Meteo do pobierania danych pogodowych dla wybranego miasta.

**Wyświetlanie logów:**
![Image](https://github.com/user-attachments/assets/239fcb37-a4ef-43a7-8d86-85814db337fa)

**Zdjęcia z działania aplikacji:**
![Image](https://github.com/user-attachments/assets/b45cccec-e2e2-48ca-b0ff-b588be7c401e)
![Image](https://github.com/user-attachments/assets/bb3dfc28-f115-4fae-9902-d297d0751609)

## 2. Opracowanie Dockerfile – budowa kontenera dla aplikacji pogodowej
W ramach tego punktu opracowałem plik ``Dockerfile``, który umożliwia uruchomienie stworzonej wcześniej aplikacji Node.js jako kontenera Docker. Plik wykorzystuje dobre praktyki budowania obrazów: wieloetapowe budowanie (``multi-stage build``), oddzielenie zależności, cache’owanie oraz zgodność ze standardami OCI.
Dockerfile: [Plik Dockerfile](Dockerfile)

## 3. Budowanie, uruchamianie oraz analiza kontenera
Poniżej przedstawiam komplet poleceń niezbędnych do obsługi obrazu aplikacji pogodowej stworzonej w punktach wcześniejszych.

a) Budowanie obrazu kontenera

```bash
docker build -t zad1_docker .
```

b) Uruchomienie kontenera na podstawie zbudowanego obrazu
```bash
docker run -d --rm --name zad1_docker_test -p 3000:3000 zad1_docker
```

c) Wyświetlenie logów aplikacji uruchomionej w kontenerze
```bash
docker logs zad1_docker_test
```
Działanie:
![Image](https://github.com/user-attachments/assets/515a9e4f-7284-4b32-b902-98412869ed4b)

d) Sprawdzenie liczby warstw oraz rozmiaru zbudowanego obrazu
```bash
docker history zad1_docker
```
Działanie:
![Image](https://github.com/user-attachments/assets/0044c520-8e15-4702-a920-0487ea6b994c)

```bash
docker images zad1_docker
```
Całkowity rozmiar obrazu:
![Image](https://github.com/user-attachments/assets/73223f2a-52a8-43f5-b055-303f102ca018)