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
  displayOrder int
);

CREATE TABLE Page (
  id           text PRIMARY KEY,
  name         text NOT NULL UNIQUE,
  title        text,
  content      text,
  displayOrder text
);

CREATE TABLE Category (
  id           text PRIMARY KEY,
  name         text NOT NULL,
  displayOrder int,
  topicCount   int
);

CREATE TABLE Topic (
  id           text PRIMARY KEY,
  title        text NOT NULL,
  content      text,
  categoryId   text NOT NULL,
  createdAt    int  NOT NULL,
  updatedAt    int,
  tags         text,
  state        text,
  viewCount    int,
  commentCount int
);

CREATE TABLE Tag (
  id         text PRIMARY KEY,
  name       text NOT NULL UNIQUE,
  topicCount int
);

CREATE TABLE Comment (
  id              text PRIMARY KEY,
  topicId         text NOT NULL,
  parentCommentId text,
  content         text NOT NULL,
  username        text NOT NULL,
  email           text,
  website         text,
  createdAt       int  NOT NULL,
  updatedAt       int,
  state           String
);

CREATE TABLE Link (
  id           text PRIMARY KEY,
  link         text NOT NULL,
  name         text NOT NULL,
  displayOrder text
)


