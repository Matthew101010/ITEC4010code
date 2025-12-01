--  VOLUNTEER SYSTEM DATABASE

-- 1. DROP TABLES IF THEY ALREADY EXIST (for clean reset)
DROP TABLE IF EXISTS applications CASCADE;
DROP TABLE IF EXISTS postings CASCADE;
DROP TABLE IF EXISTS organizations CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 2. USERS TABLE
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('volunteer', 'manager')),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. ORGANIZATIONS TABLE
CREATE TABLE organizations (
    organization_id SERIAL PRIMARY KEY,
    organization_name VARCHAR(150) NOT NULL,
    description TEXT,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(150),
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- 4. POSTINGS TABLE
CREATE TABLE postings (
    posting_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL,
    created_by INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(200),
    category VARCHAR(100),
    requirements TEXT,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- 5. APPLICATIONS TABLE
CREATE TABLE applications (
    application_id SERIAL PRIMARY KEY,
    volunteer_id INTEGER NOT NULL,
    posting_id INTEGER NOT NULL,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending' 
        CHECK (status IN ('pending', 'accepted', 'rejected')),
    notes TEXT,

    FOREIGN KEY (volunteer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (posting_id) REFERENCES postings(posting_id) ON DELETE CASCADE
);

-- 6.  SAMPLE DATA
INSERT INTO users (full_name, email, password_hash, role, phone, address)
VALUES
('John Vera', 'john.vera@example.com', 'testhash123', 'volunteer', '416-555-1010', '12 Oak St, Toronto ON'),
('Emily Helper', 'emily.helper@example.com', 'testhash123', 'volunteer', '416-555-2020', '55 Pine Rd, Toronto ON'),
('Marcus Lee', 'marcus.lee@example.com', 'testhash123', 'volunteer', '416-555-2233', '77 Birch St, Toronto ON'),
('Lena Cruz', 'lena.cruz@example.com', 'testhash123', 'volunteer', '416-555-2444', '10 Park Ave, Toronto ON'),

('Sarah Martin', 'sarah.martin@example.com', 'testhash123', 'manager', '416-555-3030', '200 King St, Toronto ON'),
('Michael Card', 'michael.card@example.com', 'testhash123', 'manager', '416-555-4040', '10 Bay St, Toronto ON'),
('Alice Brown', 'alice.brown@example.com', 'testhash123', 'manager', '647-555-1212', '45 Queen St, Toronto ON'),
('David Edwards', 'david.edwards@example.com', 'testhash123', 'manager', '647-555-9898', '9 River Rd, Toronto ON');


INSERT INTO organizations (organization_name, description, address, phone, email, created_by)
VALUES
('Community Support Center', 'Provides food and community assistance.', '123 Maple Ave, Toronto ON', '416-555-1111', 'info@csc.org', 5),
('Youth Connect Group', 'Tutoring and youth development programs.', '500 College St, Toronto ON', '416-555-2222', 'contact@youthconnect.ca', 6),
('Essence Mental Health', 'Mental health support and counseling.', '600 College St, Toronto ON', '416-555-4442', 'support@essencemental.org', 6),
('Hillcrest Community Center', 'Recreation and community activities.', '32 Hillcrest St, Toronto ON', '416-231-5780', 'hello@hillcrest.org', 5),
('GreenEarth Initiative', 'Environmental cleanups and eco-projects.', '12 Lakeshore Blvd, Toronto ON', '416-555-7777', 'info@greenearth.ca', 7),
('Pet Friends Rescue', 'Animal rescue and adoption services.', '89 Kennel Ave, Toronto ON', '416-555-9090', 'contact@petfriends.ca', 7),
('Golden Age Seniors Home', 'Support services for elderly residents.', '35 Sunrise St, Toronto ON', '647-555-4321', 'care@goldenage.ca', 8),
('Toronto Community Kitchen', 'Food services for low-income families.', '80 Dundas St W, Toronto ON', '647-555-8989', 'kitchen@tck.ca', 8);


INSERT INTO postings (organization_id, created_by, title, description, location, category, requirements, start_date, end_date)
VALUES
(1, 5, 'Food Bank Assistant', 'Distribute food to families in need.', 'Toronto, ON', 'Community Support', 'Able to lift 20 lbs', '2025-01-10', '2025-03-10'),
(1, 5, 'Event Volunteer', 'Help with setup and teardown of events.', 'Toronto, ON', 'Events', 'Teamwork required', '2025-02-01', '2025-02-28'),
(2, 6, 'Youth Tutor', 'Help children with homework.', 'Toronto, ON', 'Education', 'Experience with kids preferred', '2025-01-15', '2025-06-01'),
(3, 6, 'Mental Health Support Assistant', 'Assist staff with wellness events.', 'Toronto, ON', 'Health', 'Empathy and communication', '2025-03-01', '2025-05-01'),
(4, 5, 'Community Sports Coach', 'Coach youth sports programs.', 'Toronto, ON', 'Sports', 'Coaching experience an asset', '2025-04-10', '2025-08-01'),
(5, 7, 'Park Cleanup Volunteer', 'Join a team to clean local parks.', 'Toronto, ON', 'Environment', 'Comfortable outdoors', '2025-02-15', '2025-03-30'),
(5, 7, 'Tree Planting Volunteer', 'Assist with tree planting events.', 'Toronto, ON', 'Environment', 'Light lifting required', '2025-03-20', '2025-04-20'),
(6, 7, 'Animal Care Assistant', 'Help clean cages and feed animals.', 'Toronto, ON', 'Animal Care', 'Love for animals', '2025-01-20', '2025-03-01'),
(7, 8, 'Senior Companion', 'Visit seniors and provide conversation.', 'Toronto, ON', 'Elderly Support', 'Patience and kindness', '2025-02-10', '2025-07-10'),
(8, 8, 'Community Kitchen Helper', 'Prepare meals for families.', 'Toronto, ON', 'Food Service', 'Safe food handling preferred', '2025-01-05', '2025-04-05');


INSERT INTO applications (volunteer_id, posting_id, status, notes)
VALUES
(1, 1, 'pending', 'Excited to volunteer!'),
(1, 3, 'pending', 'Weekends only.'),
(1, 6, 'accepted', 'Strong candidate.'),
(1, 10, 'rejected', 'Schedule conflict.'),

(2, 1, 'accepted', 'Reliable volunteer.'),
(2, 2, 'pending', 'Available evenings.'),
(2, 5, 'pending', NULL),
(2, 9, 'accepted', 'Great interview.'),

(3, 3, 'pending', 'Good tutoring experience.'),
(3, 4, 'rejected', 'Position filled.'),
(3, 7, 'pending', 'Interested in tree planting.'),
(3, 8, 'accepted', NULL),

(4, 2, 'pending', NULL),
(4, 9, 'pending', 'Available every Thursday.'),
(4, 10, 'accepted', 'Strong teamwork skills.');
