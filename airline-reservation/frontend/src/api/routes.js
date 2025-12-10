import axios from 'axios';

// Default backend base on port 8003
const DEFAULT_BASE = 'http://localhost:8003/api/admin';
const BASE_URL = process.env.REACT_APP_API_BASE_URL || DEFAULT_BASE;

export async function fetchShortestPaths(origin, destination, opts = {}) {
  const { max_hops = 8, max_results = 5 } = opts;
  const params = { origin, destination, max_hops, max_results };
  const url = `${BASE_URL}/routes/path`;
  const { data } = await axios.get(url, { params });
  return data;
}

