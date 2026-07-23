# Examen MLOps — Déploiement Avancé avec Nginx

**Auteur :** Xavier Henry
**Dépôt :** https://github.com/XavierHENRY56610/mlops-nginx-exam-2

## Architecture

Ce projet met en place une passerelle Nginx (API Gateway) devant deux versions d'une API FastAPI de classification de sentiment, avec sécurité, scalabilité et monitoring complets.

## Fonctionnalités implémentées

1. **Reverse Proxy** : Nginx est l'unique point d'entrée public (port 443 HTTPS / 80 redirigé).
2. **Load Balancing** : `api-v1` est déclaré avec `deploy: replicas: 3` dans `docker-compose.yml`. Nginx distribue les requêtes en Round Robin via le bloc `upstream api-v1`.
3. **HTTPS** : Certificat auto-signé généré avec `openssl` (`deployments/nginx/certs/`). Le port 80 redirige automatiquement (301) vers le port 443.
4. **Authentification basique** : L'endpoint `/predict` est protégé par `.htpasswd` (utilisateur `admin`).
5. **Rate Limiting** : `limit_req_zone` limite à 10 requêtes/seconde par IP, avec un burst de 5.
6. **A/B Testing** : Une directive `map` dans `nginx.conf` inspecte le header `X-Experiment-Group`. Si sa valeur est `debug`, la requête est routée vers `api-v2` (réponse enrichie) ; sinon elle va vers `api-v1` (réponse standard).
7. **Monitoring (bonus)** : `nginx_exporter` expose les métriques de `/nginx_status`. Prometheus scrape cet exporter. Grafana est connecté à Prometheus.

## Utilisation

### Démarrer le projet

    make start-project

### Arrêter le projet

    make stop-project

### Lancer les tests automatisés

    make test

Exécute tests/run_tests.sh qui valide : prédiction v1, routage A/B vers v2, échec d'authentification, rate limiting, disponibilité Prometheus, disponibilité Grafana.

### Accès aux interfaces

- API (via Nginx) : https://localhost/predict (identifiants : admin / admin)
- Prometheus : http://localhost:9090
- Grafana : http://localhost:3000 (identifiants : admin / admin)
