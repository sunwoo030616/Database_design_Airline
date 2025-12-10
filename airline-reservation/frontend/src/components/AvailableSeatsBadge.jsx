import React, { useEffect, useState } from 'react';
import { getAvailableSeats } from '../api/flights';

export default function AvailableSeatsBadge({ flightId, className = '' }) {
  const [count, setCount] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!flightId) return;
    (async () => {
      try {
        const data = await getAvailableSeats(flightId);
        setCount(data?.available_count ?? null);
      } catch (e) {
        setError(e);
        setCount(null);
      }
    })();
  }, [flightId]);

  if (error || typeof count !== 'number') return null;

  return (
    <span className={`badge badge--available ${className}`}>가용 좌석 {count}석</span>
  );
}
