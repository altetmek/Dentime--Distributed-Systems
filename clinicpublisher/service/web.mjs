import requestify from "requestify";

export default class WebService {
  static async get(path) {
    const res = await requestify.request(path, { method: "GET" });
    const resJSON = JSON.parse(res.body);
    return resJSON;
  }
}
