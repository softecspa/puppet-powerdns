CREATE TABLE domains (
    id              INT AUTO_INCREMENT,
    name            VARCHAR(255) NOT NULL,
    master          VARCHAR(128) DEFAULT NULL,
    last_check      INT DEFAULT NULL,
    type            VARCHAR(6) NOT NULL,
    notified_serial INT DEFAULT NULL, 
    account         VARCHAR(40) DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY name_index (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE records (
    id              INT auto_increment,
    domain_id       INT NOT NULL,
    name            VARCHAR(255) DEFAULT NULL,
    type            VARCHAR(10) DEFAULT NULL,
    content         VARCHAR(64000) DEFAULT NULL,
    ttl             INT DEFAULT NULL,
    prio            INT DEFAULT NULL,
    change_date     INT DEFAULT NULL,
    disabled        INT DEFAULT NULL,
    ordername       VARCHAR(255) BINARY,
    auth bool,
    PRIMARY KEY (id),
    KEY rec_name_index (name),
    KEY nametype_index (name, type),
    KEY domain_id (domain_id),
    CONSTRAINT rec_fkey_domain FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE INDEX recordorder on records (domain_id, ordername);

CREATE TABLE supermasters (
    ip         VARCHAR(64) NOT NULL,
    nameserver VARCHAR(255) NOT NULL,
    account    VARCHAR(40) DEFAULT NULL,
    PRIMARY KEY (ip, nameserver)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE slave_control (
    id              INT auto_increment,
    domain_id       INT DEFAULT NULL,
    check_date      datetime,
    status          char(1),
    PRIMARY KEY (id),
    KEY domain_slave_id (domain_id),
    CONSTRAINT key_slave_domain FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE domainmetadata (
    id         INT auto_increment,
    domain_id  INT NOT NULL,
    kind       VARCHAR(16),
    content    TEXT,
    primary key(id)
) Engine=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE INDEX domainmetaidindex on domainmetadata(domain_id);

CREATE TABLE cryptokeys (
    id         INT auto_increment,
    domain_id  INT NOT NULL,
    flags      INT NOT NULL,
    active     BOOL,
    content    TEXT,
    primary key(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create index domainidindex on cryptokeys(domain_id);

create table tsigkeys (
    id         INT auto_increment,
    name       VARCHAR(255),
    algorithm  VARCHAR(50),
    secret     VARCHAR(255),
    primary key(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create unique index namealgoindex on tsigkeys(name, algorithm);
