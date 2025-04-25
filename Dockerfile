# === Stage 1: Builder ===
# Utilise une image Node avec les outils nécessaires
FROM node:18-alpine AS builder

# Définit le répertoire de travail
WORKDIR /app

# Copie package.json et package-lock.json (ou yarn.lock)
COPY package*.json ./

# Installe TOUTES les dépendances (y compris devDependencies nécessaires pour 'nest build')
# Utilise 'npm ci' pour une installation propre et reproductible depuis package-lock.json
RUN npm ci

# Copie tout le reste du code source (src, tsconfig.json, etc.)
COPY . .

# Exécute la commande de build NestJS pour compiler TS -> JS dans /app/dist
RUN npm run build

# === Stage 2: Production Runner ===
# Utilise une image Node légère pour la production
FROM node:18-alpine

WORKDIR /app

# Copie package.json et package-lock.json depuis le builder pour installer uniquement les dépendances de prod
COPY --from=builder /app/package*.json ./

# Installe UNIQUEMENT les dépendances de production
RUN npm ci --only=production

# Copie le code compilé (dossier 'dist') depuis la phase builder
COPY --from=builder /app/dist ./dist

# Copie les node_modules de production depuis la phase builder (peut accélérer un peu)
# COPY --from=builder /app/node_modules ./node_modules # Décommente si l'étape npm ci --only=production est lente ou pose problème

# Le port par défaut de NestJS est souvent 3000 (vérifie dans src/main.ts si besoin)
EXPOSE 3000

# Commande pour lancer l'application compilée en production
CMD ["node", "dist/main"]