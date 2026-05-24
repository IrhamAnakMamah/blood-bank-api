-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "postgis";-- Users (Donor)
CREATE TABLE IF NOT EXISTS users (
id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
nik           
VARCHAR(16) UNIQUE NOT NULL,
full_name     
email         
phone         
blood_type    
birth_date    
gender        
VARCHAR(100) NOT NULL,
VARCHAR(100) UNIQUE,
VARCHAR(15) NOT NULL,
VARCHAR(3) NOT NULL,
DATE NOT NULL,
CHAR(1) NOT NULL,
address       TEXT,
latitude      
DECIMAL(10,8) NOT NULL DEFAULT 0,
longitude     
DECIMAL(11,8) NOT NULL DEFAULT 0,
location      GEOGRAPHY(POINT,4326),
photo_url     
VARCHAR(500),
device_token  VARCHAR(500),
last_donation DATE,
next_eligible DATE GENERATED ALWAYS AS (last_donation + INTERVAL '60 days') 
STORED,
is_eligible   
BOOLEAN DEFAULT TRUE,
is_active     
BOOLEAN DEFAULT TRUE,
created_at    TIMESTAMPTZ DEFAULT NOW(),
updated_at    TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_users_location   
next_eligible);
password   
);
ON users USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_users_blood_type ON users(blood_type);
CREATE INDEX IF NOT EXISTS idx_users_eligible   
ON users(is_eligible, -- Admin Users
CREATE TABLE IF NOT EXISTS admin_users (
id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
username   
VARCHAR(50) UNIQUE NOT NULL,
VARCHAR(255) NOT NULL,
full_name  VARCHAR(100) NOT NULL,
role       
VARCHAR(20) DEFAULT 'OPERATOR',
is_active  BOOLEAN DEFAULT TRUE,
created_at TIMESTAMPTZ DEFAULT NOW() 

CREATE TABLE IF NOT EXISTS hospitals (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name       VARCHAR(200) NOT NULL,
  address    TEXT,
  latitude   DECIMAL(10,8),
  longitude  DECIMAL(11,8),
  pic_name   VARCHAR(100),
  pic_phone  VARCHAR(15),
  email      VARCHAR(100),
  is_active  BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);-- Blood Stock
CREATE TABLE IF NOT EXISTS blood_stock (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  blood_type         VARCHAR(3) NOT NULL,
  product_type       VARCHAR(15) NOT NULL,
  quantity           INT NOT NULL DEFAULT 0,
  safe_threshold     INT DEFAULT 10,
  critical_threshold INT DEFAULT 3,
  updated_at         TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(blood_type, product_type)
);-- Blood Requests
CREATE TABLE IF NOT EXISTS blood_requests (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hospital_id    UUID REFERENCES hospitals(id),
  requested_by   VARCHAR(100),
  blood_type     VARCHAR(3) NOT NULL,
  product_type   VARCHAR(15) DEFAULT 'PRC',
  quantity_needed INT NOT NULL,
  urgency_level  VARCHAR(10) NOT NULL,
  notes          TEXT,
  broadcast_id   VARCHAR(100),
  status         VARCHAR(15) DEFAULT 'PENDING',
  admin_id       UUID REFERENCES admin_users(id),
  created_at     TIMESTAMPTZ DEFAULT NOW(),
  fulfilled_at   TIMESTAMPTZ
);
-- Donation History
CREATE TABLE IF NOT EXISTS donation_history (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  donor_id          UUID REFERENCES users(id) NOT NULL,
  request_id        UUID REFERENCES blood_requests(id),
  donation_date     DATE NOT NULL,
  pmi_location      VARCHAR(200),
  blood_pressure    VARCHAR(20),
  hemoglobin        DECIMAL(4,1),
  weight            DECIMAL(5,2),
  volume_ml         INT DEFAULT 350,
  is_eligible       BOOLEAN,
  disqualify_reason TEXT,
status            
VARCHAR(15) DEFAULT 'CHECKED_IN',
admin_id          UUID REFERENCES admin_users(id),
created_at        TIMESTAMPTZ DEFAULT NOW()
);
-- Stock Transactions (Audit Log) — FR-A08
CREATE TABLE IF NOT EXISTS stock_transactions (
id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
blood_type           
VARCHAR(3) NOT NULL,
product_type         
quantity_change      
quantity_before      
quantity_after       
action_type          
VARCHAR(15) NOT NULL,
INT NOT NULL,        
INT NOT NULL,
INT NOT NULL,-- positif = tambah, negatif = kurangi
VARCHAR(20) NOT NULL, -- DONATION_IN | DISTRIBUTION_OUT | ADJUSTMENT
reference_request_id UUID REFERENCES blood_requests(id),
admin_id             UUID REFERENCES admin_users(id) NOT NULL,
notes                TEXT,
created_at           TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_stock_tx_blood   
product_type);
CREATE INDEX IF NOT EXISTS idx_stock_tx_admin   
ON stock_transactions(blood_type, 
ON stock_transactions(admin_id);
CREATE INDEX IF NOT EXISTS idx_stock_tx_created ON stock_transactions(created_at 
DESC);
-- Seed initial blood stock
INSERT INTO blood_stock (blood_type, product_type, quantity) VALUES
('A+','WB',0),('A+','PRC',0),('A+','FFP',0),('A+','THROMBOCYTE',0),
('A-','WB',0),('A-','PRC',0),('A-','FFP',0),('A-','THROMBOCYTE',0),
('B+','WB',0),('B+','PRC',0),('B+','FFP',0),('B+','THROMBOCYTE',0),
('B-','WB',0),('B-','PRC',0),('B-','FFP',0),('B-','THROMBOCYTE',0),
('O+','WB',0),('O+','PRC',0),('O+','FFP',0),('O+','THROMBOCYTE',0),
('O-','WB',0),('O-','PRC',0),('O-','FFP',0),('O-','THROMBOCYTE',0),
('AB+','WB',0),('AB+','PRC',0),('AB+','FFP',0),('AB+','THROMBOCYTE',0),
('AB-','WB',0),('AB-','PRC',0),('AB-','FFP',0),('AB-','THROMBOCYTE',0)
ON CONFLICT DO NOTHING;