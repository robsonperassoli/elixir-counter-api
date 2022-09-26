import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  stages: [{ duration: "3m", target: 200 }],
};

export default function () {
  const url = "http://localhost:3333/increment";
  const payload = { key: "errors", value: 1 };

  const res = http.post(url, JSON.stringify(payload), {
    headers: { "Content-Type": "application/json" },
  });

  check(res, { "status was 202": (r) => r.status == 202 });

  sleep(1);
}
