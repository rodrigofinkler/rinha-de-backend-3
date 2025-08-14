import express, { Router, Request, Response } from "express";
import axios, { isAxiosError } from "axios";
import { DBClient } from "./database_client";

const app = express();
const port = 8080;

const routes = Router();

// GET routes
routes.get("/", (_req: Request, res: Response) => {
  console.log("HTTP GET @ /");
  res.send("😎");
});

routes.get("/payments-summary", async (req: Request, res: Response) => {
  console.log("HTTP GET @ /payments-summary");
  try {
    const sql_query = `
      SELECT 
        COUNT(*) as total
      FROM payments;`;
    const db = `rinha`;
    // const db_res = await DBClient.query<Array<any>>(sql_query, db, [], true);
    // if (db_res[0].length === 0) {
    //   return res.sendStatus(404);
    // }
    const out = {
      default: {
        totalRequests: 43236,
        totalAmount: 415542345.98,
      },
      fallback: {
        totalRequests: 423545,
        totalAmount: 329347.34,
      },
    };
    res.json(out);
  } catch (err: any) {
    console.error(err);
    return res.status(500).json({ err });
  }
});

// POST routes

// POST /payments
// {
//     "correlationId": "4a7901b8-7d26-4d9d-aa19-4dc1c7cf60b3",
//     "amount": 19.90
// }

// HTTP 2XX
// Qualquer coisa
routes.post("/payments", async (req: Request, res: Response) => {
  console.log("HTTP POST @ /payments");
  try {
    const requestedAt = new Date().toISOString();
    const { correlationId, amount } = req.body;

    // At first, let's just try to post directly to Payment Processor 1
    try {
      const paymentsProcessor_res = await axios.post(
        "http://localhost:8001/payments",
        {
          correlationId,
          amount,
          requestedAt,
        }
      );
      console.log(paymentsProcessor_res.data?.message);
    } catch (err) {
      if (isAxiosError(err)) {
        if (err?.status == 500) {
          const paymentsProcessor_res = await axios.post(
            "http://localhost:8002/payments",
            {
              correlationId,
              amount,
              requestedAt,
            }
          );
          console.log(paymentsProcessor_res.data?.message);
        }

        res.status(201).json({
          message: "Ta funcionando o PP2",
          requestedAt,
        });
      }
    }

    res.status(200).json({
      message: "Ta funcionando",
      requestedAt,
    });
  } catch (err) {
    res.sendStatus(500);
  } finally {
    return res;
  }
});

app.use(express.json());
app.use(routes);

app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});

export default app;
