// src/pages/Register.jsx
import { useState } from "react";
import { register } from "../api/auth";
import { useNavigate } from "react-router-dom";
import "./Register.css";

export default function Register() {
  const navigate = useNavigate();

  const [form, setForm] = useState({
    name: "",
    email: "",
    password: "",
    phone_num: "",
  });

  function updateField(field, value) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleRegister() {
    const { name, email, password } = form;

    if (!name || !email || !password) {
      alert("필수 정보를 입력하세요.");
      return;
    }

    try {
      const res = await register(form);

      localStorage.setItem("token", res.data.token);
      localStorage.setItem("member", JSON.stringify(res.data.member));

      navigate("/");
    } catch (e) {
      console.error(e);
      alert("회원가입 실패 (이미 존재하는 이메일일 수 있음)");
    }
  }

  return (
    <div className="register-container">
      <div className="register-card">
        <h2 className="register-title">AirFly 회원가입</h2>

        <div className="input-group">
          <label>이름</label>
          <input
            placeholder="홍길동"
            onChange={(e) => updateField("name", e.target.value)}
          />
        </div>

        <div className="input-group">
          <label>이메일</label>
          <input
            type="email"
            placeholder="example@airfly.com"
            onChange={(e) => updateField("email", e.target.value)}
          />
        </div>

        <div className="input-group">
          <label>비밀번호</label>
          <input
            type="password"
            placeholder="비밀번호 입력"
            onChange={(e) => updateField("password", e.target.value)}
          />
        </div>

        <div className="input-group">
          <label>전화번호</label>
          <input
            placeholder="010-1234-5678"
            onChange={(e) => updateField("phone_num", e.target.value)}
          />
        </div>

        <button className="register-btn" onClick={handleRegister}>
          가입하기
        </button>

        <div className="login-text">
          이미 계정이 있나요?{" "}
          <span onClick={() => navigate("/login")}>로그인</span>
        </div>
      </div>
    </div>
  );
}
