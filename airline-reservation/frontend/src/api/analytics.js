// Unified analytics API: use shared axios instance and avoid duplicates
import api from './axios';

export async function fetchRevenueRollup(params = {}) {
  const res = await api.get('/admin/revenue/rollup', { params });
  return res.data;
}

export async function fetchRevenueCube(params = {}) {
  const res = await api.get('/admin/revenue/cube', { params });
  return res.data;
}
