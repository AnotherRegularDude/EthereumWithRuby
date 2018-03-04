SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_editions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_editions (
    id bigint NOT NULL,
    title text NOT NULL,
    isbn10 text NOT NULL,
    isbn13 text NOT NULL,
    edition integer,
    binding integer,
    author text,
    description text,
    publish_date date,
    price integer,
    width integer,
    height integer,
    depth integer,
    deleted boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_editions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE book_editions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: book_editions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE book_editions_id_seq OWNED BY book_editions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: book_editions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_editions ALTER COLUMN id SET DEFAULT nextval('book_editions_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: book_editions book_editions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_editions
    ADD CONSTRAINT book_editions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_book_editions_on_author; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_editions_on_author ON book_editions USING btree (author);


--
-- Name: index_book_editions_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_editions_on_description ON book_editions USING btree (description);


--
-- Name: index_book_editions_on_isbn10_and_isbn13; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_editions_on_isbn10_and_isbn13 ON book_editions USING btree (isbn10, isbn13);


--
-- Name: index_book_editions_on_isbn13; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_editions_on_isbn13 ON book_editions USING btree (isbn13);


--
-- Name: index_book_editions_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_editions_on_title ON book_editions USING btree (title);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180304033703'),
('20180304062744');


