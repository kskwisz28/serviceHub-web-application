SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: alert_bars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alert_bars (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text NOT NULL,
    button_text text,
    url text,
    active boolean DEFAULT false NOT NULL
);


--
-- Name: alert_bars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alert_bars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alert_bars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alert_bars_id_seq OWNED BY public.alert_bars.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_messages (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email_body text,
    literature_asset_urls text[] DEFAULT '{}'::text[],
    customer_email text,
    status text,
    user_id bigint NOT NULL
);


--
-- Name: email_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_messages_id_seq OWNED BY public.email_messages.id;


--
-- Name: feedback_email_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedback_email_messages (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    subject_line text,
    body text,
    sender_email text
);


--
-- Name: feedback_email_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedback_email_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_email_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedback_email_messages_id_seq OWNED BY public.feedback_email_messages.id;


--
-- Name: lead_passes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lead_passes (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name text,
    last_name text,
    company text,
    "position" text,
    phone text,
    email text,
    notes text,
    reference_instrument text,
    email_body text,
    training boolean,
    consulting_services boolean,
    qualifications boolean,
    instrument_service_plans boolean,
    region text,
    country text,
    zip text,
    user_id bigint,
    instrument_nickname text,
    serial_number text
);


--
-- Name: lead_passes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lead_passes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_passes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lead_passes_id_seq OWNED BY public.lead_passes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email text NOT NULL,
    country_code text NOT NULL,
    role text NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: alert_bars id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_bars ALTER COLUMN id SET DEFAULT nextval('public.alert_bars_id_seq'::regclass);


--
-- Name: email_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_messages ALTER COLUMN id SET DEFAULT nextval('public.email_messages_id_seq'::regclass);


--
-- Name: feedback_email_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_email_messages ALTER COLUMN id SET DEFAULT nextval('public.feedback_email_messages_id_seq'::regclass);


--
-- Name: lead_passes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lead_passes ALTER COLUMN id SET DEFAULT nextval('public.lead_passes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: alert_bars alert_bars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_bars
    ADD CONSTRAINT alert_bars_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: email_messages email_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_messages
    ADD CONSTRAINT email_messages_pkey PRIMARY KEY (id);


--
-- Name: feedback_email_messages feedback_email_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_email_messages
    ADD CONSTRAINT feedback_email_messages_pkey PRIMARY KEY (id);


--
-- Name: lead_passes lead_passes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lead_passes
    ADD CONSTRAINT lead_passes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_alert_bars_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_alert_bars_on_active ON public.alert_bars USING btree (active) WHERE (active = true);


--
-- Name: index_email_messages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_messages_on_user_id ON public.email_messages USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210223180919'),
('20210314213605'),
('20210408233327'),
('20210413015513'),
('20210422193847'),
('20210422225051'),
('20210426030718');


