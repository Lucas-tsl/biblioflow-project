// s'exécute côté root (authSource=admin)
db = db.getSiblingDB(process.env.MONGO_DB || "biblio_logs");
db.createCollection("logs");
db.logs.createIndex({ ts: 1 });

print("Mongo init OK: created db="+db.getName()+" and collection=logs");
