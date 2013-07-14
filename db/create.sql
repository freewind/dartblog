CREATE TABLE User (
  id       text PRIMARY KEY,
  email    text NOT NULL UNIQUE,
  name     text NOT NULL,
  password text NOT NULL,
  salt     text NOT NULL
);

CREATE TABLE Config (
  id           text PRIMARY KEY,
  code         text NOT NULL UNIQUE,
  value        text,
  desc         text,
  displayOrder int DEFAULT 0
);

CREATE TABLE Page (
  id           text PRIMARY KEY,
  name         text NOT NULL UNIQUE,
  title        text,
  content      text,
  displayOrder text DEFAULT 0
);

CREATE TABLE Category (
  id           text PRIMARY KEY,
  name         text NOT NULL,
  displayOrder int DEFAULT 0,
  topicCount   int DEFAULT 0
);

CREATE TABLE Topic (
  id           text PRIMARY KEY,
  title        text      NOT NULL,
  content      text,
  categoryId   text      NOT NULL,
  createdAt    timestamp NOT NULL,
  updatedAt    timestamp,
  tags         text,
  state        text DEFAULT 'normal',
  viewCount    int DEFAULT 0,
  commentCount int DEFAULT 0
);

CREATE TABLE Tag (
  id         text PRIMARY KEY,
  name       text NOT NULL UNIQUE,
  topicCount int DEFAULT 0
);

CREATE TABLE Comment (
  id              text PRIMARY KEY,
  topicId         text      NOT NULL,
  parentCommentId text,
  content         text      NOT NULL,
  username        text      NOT NULL,
  email           text,
  website         text,
  createdAt       timestamp NOT NULL,
  updatedAt       timestamp,
  state           boolean DEFAULT 'checking'
);

CREATE TABLE Link (
  id           text PRIMARY KEY,
  link         text NOT NULL,
  name         text NOT NULL,
  displayOrder text DEFAULT 0
)


