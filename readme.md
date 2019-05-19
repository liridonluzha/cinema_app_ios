## Filmrausch-App

Die Filmrausch-App nutzt den selben API-Endpunkt wie [die Filmrausch-Website](http://filmrausch.hdm-stuttgart.de/), 
um Nutzern schnell und hübsch den Kinoplan für das wöchentliche HdM-Stundentenkino anzuzeigen. 
Zusätzlich verfügt die App über interaktive Funktionen wie die Möglichkeit, eine Losnummer zu ziehen um vor dem Film an einer Verlosung teilzunehmen.
Außerdem können Filme direkt aus der App in den eigenen Kalender gespeichert werden, sowie Filmvorschläge eingereicht werden.

### Team
Das Projekt Filmrausch-App wird durchgeführt von [Liridon Luzha](mailto:ll032@hdm-stuttgart.de) und [Leonard Wohlfarth](mailto:lw062@hdm-stuttgart.de).  
Besonders Wert gelegt haben wir auf die Kategorien **Networking** (in Form von schnellen, asynchronen API-Abfragen und Offline-Caching) und **Connectivity** (mit dem Zusammenspiel von
erweitertem Bluetooth LE Scanning und Netzwerkstandort).

### Die Liste der Filme

Unter http://filmrausch.hdm-stuttgart.de/api findet sich die Filmrausch-API eine Liste aller Filme in diesem Semester, 
inklusive einiger Informationen, Werbetexten und einem Poster-Link zu jedem Film. Dazu kommen organisatorische Informationen wie das aktuelle Semester oder 
die in diesem Semester für den Filmrausch Hauptverantwortlichen.

### Networking

Um die App komplett zu laden, müssen mehrere Anfragen an diverse Server gesendet und empfangen werden. Zuerst die Liste der Filme, anschließend alle Postergrafiken, und eventuell
anschließend der Endpunkt für Losnummern.
Dies war eine besondere Herausforderung, da der Vorteil einer App gegenüber
der existierenden mobilen Website eine stressfreie offline-Nutzung sein sollte. Hierfür werden Schlüsselinformationen auf dem Gerät selbst gespeichert, und aktualisiert sobald neue
Informationen zur Verfügung stehen. So startet die App nahezu ohne Ladezeiten direkt in eine Übersicht aller Filme des Semesters.
Erst im Anschluss wird die API abgefragt, und die Liste der Filme bei Bedarf aktualisiert. Für jeden geladenen Film wird außerdem ein weiterer Request gestartet, um das zum Film zugeörige Poster
asynchron dazuzuladen.

### Verlosungen

Für jeden einzelnen Film können Nutzer\*innen eine Losnummer ziehen, aus welchen vor jeder Vorstellung ein/e Gewinner\*in gezogen wird. Diese Verlosungen nutzen Firebase Cloud
Functions, angebunden an eine FIrebase Realtime Database. Das Abfragen einer Losnummer erhöht in dieser Datenbank eine Integer, das Ergebnis wird in den SharedPreferences
gespeichert um zu gewährleisten, dass jeder Nutzer nur eine Nummer pro Film bekommt.

### Standorterkennung

In allen Filmrausch-Kinos wurde ein Bluetooth Beacon platziert, dessen Mac-Adresse im Quellcode hinterlegt ist. Zum Start der App beginnt das Smartphone, 
nach Bluetooth Geräten in der Umgebung zu suchen. Sollte hierbei ein Gerät mit übereinstimmender Mac-Adresse und ausreichender Signalstärke auftauchen wissen wir, dass der Nutzer sich in der Nähe einer
unserer Beacons befindet. Zusätzlich fragt die App den aktuellen Standort des Nutzers ab, um zu verifizieren dass der Nutzer sich auch tatsächlich an der HdM befindet. So können
auch Geräte ohne Bluetooth unterstützt und Fälschungsmethoden wie Mac-Spoofing umgangen werden.
