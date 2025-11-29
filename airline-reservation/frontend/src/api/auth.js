import api from "./axios";

export const login = (email, password) =>
  api.post("/members/auth/login/", {
    email,
    password,
  });

export const register = (data) =>
  api.post("/members/auth/register/", data);

