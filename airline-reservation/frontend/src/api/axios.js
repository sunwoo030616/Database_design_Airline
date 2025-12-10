// src/api/axios.js
import axios from "axios";

const api = axios.create({
  baseURL: "http://127.0.0.1:8003/api",
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Public endpoints (development): do NOT attach Authorization header
const PUBLIC_PATHS = [
  '/admin/revenue/rollup',
  '/admin/revenue/cube',
  '/admin/fare-log/',
];

api.interceptors.request.use((config) => {
  const urlPath = (config.url || '').replace(/^https?:\/\/[^/]+/i, '');
  const isPublic = PUBLIC_PATHS.some((p) => urlPath.startsWith(p));
  if (!isPublic) {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
  } else {
    // Ensure Authorization header is not accidentally set for public paths
    if (config.headers && 'Authorization' in config.headers) {
      delete config.headers.Authorization;
    }
  }
  return config;
});

export default api;
