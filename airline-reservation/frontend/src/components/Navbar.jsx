// src/components/Navbar.jsx
import { Link } from "react-router-dom";
import "./Navbar.css";

export default function Navbar() {
  const memberJson = localStorage.getItem("member");
  const member = memberJson ? JSON.parse(memberJson) : null;

  function handleLogout() {
    localStorage.removeItem("token");
    localStorage.removeItem("member");
    window.location.href = "/"; // 강제 새로고침
  }

  return (
    <div className="navbar">
      <div className="nav-left">
        <div className="nav-logo">
          ✈ AirFly
        </div>
      </div>

      <div className="nav-menu">
        <Link to="/">항공편 검색</Link>
        <Link to="/routes">경로 검색</Link>
        {member && member.user_type === 'admin' && (
          <>
            <Link to="/fare-log">요금 변경 로그</Link>
            <Link to="/analytics/revenue">매출 분석</Link>
          </>
        )}
        <Link to="/mypage">마이페이지</Link>
        {member ? (
          <>
            <span className="nav-user">{member.name} 님</span>
            <button className="nav-logout" onClick={handleLogout}>
              로그아웃
            </button>
          </>
        ) : (
          <Link to="/login">로그인</Link>
        )}
      </div>
    </div>
  );
}
