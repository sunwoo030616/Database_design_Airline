// src/pages/Login.jsx
import { useState } from "react";
import { login } from "../api/auth";
import { useNavigate } from "react-router-dom";
import "./Login.css";

export default function Login() {
  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");
  const navigate = useNavigate();

  async function handleLogin() {
    if (!email || !pw) {
      alert("이메일과 비밀번호를 입력하세요.");
      return;
    }

    try {
      const res = await login(email, pw);
      localStorage.setItem("token", res.data.token);
      localStorage.setItem("member", JSON.stringify(res.data.member));
      localStorage.setItem("member_id", res.data.member.user_id);

      navigate("/");
    } catch (e) {
      console.error(e);
      alert("로그인 실패(이메일 또는 비밀번호 확인)");
    }
  }

  return (
    <div className="login-container">

      <div className="login-card">
        <h2 className="login-title">AirFly 로그인</h2>

        <div className="input-group">
          <label>이메일</label>
          <input
            type="email"
            placeholder="example@airfly.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>

        <div className="input-group">
          <label>비밀번호</label>
          <input
            type="password"
            placeholder="비밀번호 입력"
            value={pw}
            onChange={(e) => setPw(e.target.value)}
          />
        </div>

        <button className="login-btn" onClick={handleLogin}>
          로그인
        </button>

        <div className="signup-text">
          계정이 없나요?{" "}
          <span onClick={() => navigate("/register")}>회원가입</span>
        </div>
      </div>
    </div>
  );
}
