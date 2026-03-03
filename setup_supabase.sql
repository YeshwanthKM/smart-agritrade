-- Create Users table
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT CHECK (role IN ('farmer', 'buyer')) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create Crops table (Farmer listings)
CREATE TABLE crops (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    farmer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    crop_name TEXT NOT NULL,
    quantity DECIMAL NOT NULL,
    price_per_kg DECIMAL NOT NULL,
    location TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create Orders table
CREATE TABLE orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    buyer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    crop_id UUID REFERENCES crops(id) ON DELETE CASCADE,
    farmer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    quantity DECIMAL NOT NULL,
    total_price DECIMAL NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (optional but recommended for production)
-- For now, we will use the Service Role or keep it simple for the user.
