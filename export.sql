--
-- PostgreSQL database dump
--

\restrict yDoHwN3TcievVZbxAm8EVbgekYuVm644reTGVph9MTVq30cuk88oBBuAHbpwk0H

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-09-14 14:53:14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16403)
-- Name: goods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goods (
    id integer NOT NULL,
    name text NOT NULL,
    cost integer NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE public.goods OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16402)
-- Name: goods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.goods_id_seq OWNER TO postgres;

--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 221
-- Name: goods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.goods_id_seq OWNED BY public.goods.id;


--
-- TOC entry 224 (class 1259 OID 16421)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    review_text text NOT NULL,
    good_id integer NOT NULL
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16420)
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO postgres;

--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 223
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.types OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.types_id_seq OWNER TO postgres;

--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 219
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


--
-- TOC entry 4867 (class 2604 OID 16406)
-- Name: goods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goods ALTER COLUMN id SET DEFAULT nextval('public.goods_id_seq'::regclass);


--
-- TOC entry 4868 (class 2604 OID 16424)
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- TOC entry 4866 (class 2604 OID 16393)
-- Name: types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- TOC entry 5029 (class 0 OID 16403)
-- Dependencies: 222
-- Data for Name: goods; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.goods VALUES (1, 'Ноутбук', 150000, 3);
INSERT INTO public.goods VALUES (2, 'Банан', 180, 1);
INSERT INTO public.goods VALUES (3, 'Джинсы', 4000, 2);


--
-- TOC entry 5031 (class 0 OID 16421)
-- Dependencies: 224
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.reviews VALUES (1, 'Отличный ноутбук, быстрый!', 1);
INSERT INTO public.reviews VALUES (2, 'Ноутбук греется, но в целом ок', 1);
INSERT INTO public.reviews VALUES (3, 'Бананы сладкие, свежие', 2);
INSERT INTO public.reviews VALUES (4, 'Джинсы не подошли по размеру', 3);


--
-- TOC entry 5027 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.types VALUES (1, 'Продукты');
INSERT INTO public.types VALUES (2, 'Одежда');
INSERT INTO public.types VALUES (3, 'Электроника');


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 221
-- Name: goods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goods_id_seq', 3, true);


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 223
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 4, true);


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 219
-- Name: types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.types_id_seq', 3, true);


--
-- TOC entry 4874 (class 2606 OID 16414)
-- Name: goods goods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goods
    ADD CONSTRAINT goods_pkey PRIMARY KEY (id);


--
-- TOC entry 4876 (class 2606 OID 16431)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 4870 (class 2606 OID 16401)
-- Name: types types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_name_key UNIQUE (name);


--
-- TOC entry 4872 (class 2606 OID 16399)
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- TOC entry 4877 (class 2606 OID 16415)
-- Name: goods fk_goods_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goods
    ADD CONSTRAINT fk_goods_type FOREIGN KEY (type_id) REFERENCES public.types(id) ON DELETE CASCADE;


--
-- TOC entry 4878 (class 2606 OID 16432)
-- Name: reviews fk_reviews_good; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_good FOREIGN KEY (good_id) REFERENCES public.goods(id) ON DELETE CASCADE;


-- Completed on 2026-09-14 14:53:15

--
-- PostgreSQL database dump complete
--

\unrestrict yDoHwN3TcievVZbxAm8EVbgekYuVm644reTGVph9MTVq30cuk88oBBuAHbpwk0H

