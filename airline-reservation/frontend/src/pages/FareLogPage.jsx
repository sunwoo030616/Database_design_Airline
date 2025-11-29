import React, { useEffect, useState } from "react";
import { fetchFareLogs } from "../api/logs";
import "./FareLogPage.css";

export default function FareLogPage() {
  const [logs, setLogs] = useState([]);
  const [flightId, setFlightId] = useState("");

  const loadLogs = () => {
    fetchFareLogs(flightId ? flightId : null)
      .then(res => setLogs(res.data))
      .catch(err => console.error(err));
  };

  useEffect(() => {
    loadLogs();
  }, []);

  return (
    <div className="farelog-container">
      <h1>운임 변경 로그</h1>

      <div className="filter-box">
        <input
          type="number"
          placeholder="Flight ID로 필터"
          value={flightId}
          onChange={(e) => setFlightId(e.target.value)}
        />
        <button onClick={loadLogs}>조회</button>
      </div>

      {logs.length === 0 ? (
        <p>로그가 없습니다.</p>
      ) : (
        logs.map((log) => (
          <div key={log.log_id} className="farelog-card">
            <h3>Flight #{log.flight.flight_id}</h3>
            
            <p><strong>이벤트:</strong> 
              <span
                className={
                  log.event_type === "NEW_RESERVATION"
                    ? "event-new"
                    : "event-cancel"
                }
              >
                {log.event_type}
              </span>
            </p>
            
            <p><strong>운임:</strong> {log.old_fare} → <b>{log.new_fare}</b></p>
            <p><strong>시간:</strong> {log.changed_at}</p>

            {log.note && (
              <p><strong>비고:</strong> {log.note}</p>
            )}
          </div>
        ))
      )}
    </div>
  );
}
