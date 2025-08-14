import mysql, { ConnectionConfig } from "mysql2";

class DatabaseClient {
  async query<T>(
    query: string,
    databaseName?: string,
    args?: Array<any>,
    multipleStatements = false
  ): Promise<T> {
    const config: ConnectionConfig = {
      host: process.env.DB_HOST || `localhost`,
      user: `root`,
      password: `pwd`,
      port: 3306,
      database: databaseName,
      multipleStatements: multipleStatements,
    };
    try {
      var db_conn = await mysql.createConnection(config);
    } catch (err: any) {
      console.log(err);
      throw err;
    }
    try {
      return new Promise((resolve, reject) => {
        db_conn.query(query, args, async function (err, results, fields) {
          if (err) {
            reject(err);
            throw err;
          }
          return resolve(results);
        });
        db_conn.end();
      });
    } catch (err: any) {
      console.error(err?.sqlMessage || err);
      if (!!db_conn) {
        db_conn.end();
      }
      throw err;
    }
  }
}

export const DBClient: DatabaseClient = new DatabaseClient();
