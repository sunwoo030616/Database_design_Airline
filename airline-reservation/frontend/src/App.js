// src/App.js
import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";

import Navbar from "./components/Navbar";
import SearchFlights from "./pages/SearchFlights";
import Login from "./pages/Login";
import Register from "./pages/Register";
import SeatSelect from "./pages/SeatSelect";
import ReservationConfirm from "./pages/ReservationConfirm";
import MyPage from "./pages/MyPage";
import FareLogPage from "./pages/FareLogPage";
import RouteSearch from "./pages/RouteSearch";
import RevenueAnalytics from "./pages/RevenueAnalytics";





function App() {
  return (
    <BrowserRouter>
      <Navbar />
      <div style={{ maxWidth: "1100px", margin: "0 auto", padding: "30px 20px" }}>
        <Routes>
          <Route path="/" element={<SearchFlights />} />
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/seat-select/:flightId" element={<SeatSelect />} />
          <Route path="/reservation/confirm" element={<ReservationConfirm />} />
          <Route path="/mypage" element={<MyPage />} />
          <Route path="/fare-log" element={<FareLogPage />} />
          <Route path="/routes" element={<RouteSearch />} />
          <Route path="/analytics/revenue" element={<RevenueAnalytics />} />

        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;
