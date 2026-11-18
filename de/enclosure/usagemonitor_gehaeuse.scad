// =====================================================================
//  Claude Usage Monitor – Gehaeuse im Look eines 90er-Jahre-Roehrenmonitors
//  Fuer: Waveshare ESP32-S3-LCD-1.69 (quer eingebaut) + LiPo 803040
//  Eine Farbe (Cremeweiss / Beige / Hellgrau), keine Stuetzen noetig.
//
//  ZWEI VARIANTEN (unten bei "variante" waehlen):
//   "direkt" – Das USB-C-Kabel wird OBEN in eine eingelassene Mulde
//              gesteckt und sitzt direkt im Board. Jedes gerade
//              USB-C-Kabel passt. (Empfohlen, keine Zusatzteile)
//   "hinten" – Ein 90-Grad-gewinkeltes USB-C-Kabel steckt unten im
//              Board und laeuft innen nach hinten durch den Deckel.
//
//  Bedienung (OpenSCAD, kostenlos):
//    1. Datei oeffnen, "variante" und "teil" einstellen
//    2. F6 druecken (rendern), dann Datei -> Exportieren -> STL
//
//  Druck: PLA, 0.2 mm Schicht, 15 % Fuellung, keine Stuetzen
//    - Gehaeuse: aufrecht, Unterseite aufs Druckbett
//    - Deckel:   flach, Lippe nach oben
//    - Fuss:     flach, breite Seite unten
//    - Tasten:   stehend, Kappe/Kragen nach unten (bei "direkt" + 2 Knoepfe, offene Seite oben)
//
//  Alle Masse in Millimeter. Wenn deine Teile anders sind:
//  Werte im Abschnitt "MASSE DER BAUTEILE" anpassen.
// =====================================================================

variante = "direkt";  // [direkt, hinten]
teil     = "alles";   // [gehaeuse, deckel, fuss, tasten, alles]
farbe = "#EDE6D6";  // Knochenweiss / Cremeweiss = Farbe des Filaments. So zeigt die Vorschau (F5)
                    // das Gehaeuse, wie es gedruckt aussieht. Andere Filamentfarbe? Hier anpassen.


// ---------------- MASSE DER BAUTEILE (nachmessen!) --------------------
// (Angaben wie im Datenblatt, also Board HOCHKANT gemessen)
board_b   = 30.00;   // Platine Breite
board_h   = 37.12;   // Platine Hoehe
board_t   = 10.0;    // Dicke Display + Platine + Bauteile (gesamt)
glas_b    = 27.97;   // Displayglas Breite
glas_h    = 32.63;   // Displayglas Hoehe
glas_r    = 5.0;     // Eckradius Displayglas
glas_oben = 0.8;     // Abstand Glas-Oberkante zu Platinen-Oberkante

akku_b    = 30.0;    // Akku 803040
akku_h    = 40.0;
akku_t    = 8.0;

// Lage der Anschluesse (hochkant von der Platinen-OBERKANTE gemessen)
usb_y        = 19.0;  // Mitte USB-C
usb_tiefe    = 8.0;   // Mitte USB-C ab Vorderseite der Platine
pwr_y        = 6.6;   // Mitte PWR-Taste
boot_y       = 17.7;  // Mitte BOOT-Taste
taste_tiefe  = 7.5;   // Mitte der Tasten ab Vorderseite der Platine
knopf_ueber  = 0.8;   // so weit stehen die Tasten ueber den Platinenrand

// Variante "direkt": Mulde fuer den USB-C-Stecker (Kabel-Tuelle + Luft)
stecker_b    = 13.0;
stecker_d    = 7.5;

// Variante "hinten": gewinkelter Stecker
kabel_platz  = 11.0;  // Platz unter dem Board fuer den gewinkelten Stecker
kabel_d      = 5.5;   // Kabeldurchmesser (Schlitz im Deckel)

// ---------------- GEHAEUSE -------------------------------------------
wand      = 2.4;
front     = 3.0;     // Vorderwand (mit eingelassener Bildschirmkante)
spiel     = 0.4;
rand_s    = 5.0;     // Rahmen links/rechts
rand_o    = 4.0;     // Rahmen oben
ecke_r    = 3.5;
ruecken_r = 3.0;
front_d   = 11.0;    // Tiefe des geraden Rahmens vorne
tiefe_extra = 8.0;   // zusaetzliche Tiefe fuer den Roehren-Look
deckel_t  = 2.4;
lippe_t   = 3.0;
toleranz  = 0.25;

$fn = 48;

// ---------------- Abgeleitete Masse ----------------------------------
direkt = (variante == "direkt");
bl = board_h;  bh = board_b;          // Board quer
gb = glas_h;   gh = glas_b;           // Glas quer
kp = direkt ? 0 : kabel_platz;
boden = direkt ? 12 : 6;              // "direkt": massives Kinn

inn_b = max(bl, akku_h) + 2*spiel;
inn_h = kp + max(bh, akku_b) + 2*spiel + knopf_ueber + 0.4;
inn_t = board_t + akku_t + lippe_t + 0.5 + tiefe_extra;

aus_b = 2*(rand_s + wand) + inn_b;
aus_h = boden + inn_h + wand + rand_o;
aus_t = front + inn_t;

inn_x = rand_s + wand;
inn_z = boden;
rue_x = rand_s;  rue_b = aus_b - 2*rand_s;
rue_z = 0;       rue_h = aus_h - rand_o;

// Glas mittig, Board passend versetzt
g_x = aus_b/2 - gb/2;
board_x = direkt ? g_x - (bl - glas_oben - gb) : g_x - glas_oben;
board_z = direkt ? inn_z + knopf_ueber + 0.4 + spiel : inn_z + kp + spiel;
board_top = board_z + bh;
g_z = board_z + (bh - gh)/2;

// Position entlang der Platinenkante (Abstand d von der Original-Oberkante)
function kante_x(d) = direkt ? board_x + bl - d : board_x + d;
usb_x = kante_x(usb_y);

// "direkt": Nische fuer die Tasten-Knoepfe unter dem Kinn
nische_h  = 4.5;                                   // Hoehe der Nische
nische_x0 = min(kante_x(pwr_y), kante_x(boot_y)) - 6;
nische_x1 = max(kante_x(pwr_y), kante_x(boot_y)) + 6;

// Fuss-Aufnahme (bei "direkt" weiter hinten, vorne sitzen die Tasten)
zap_b = 14; zap_t = 8; zap_h = 4.5;
zap_cy = direkt ? aus_t*0.62 : aus_t*0.45;
zap_x = aus_b/2 - zap_b/2;  zap_y = zap_cy - zap_t/2;

// ---------------- Hilfsformen ----------------------------------------
module rrect2d(b, h, r) { offset(r=r) offset(delta=-r) square([b, h]); }
module slab(x, z, b, h, r, y0, t) {
  translate([0, y0 + t, 0]) rotate([90,0,0]) linear_extrude(t)
    translate([x, z]) rrect2d(b, h, r);
}

// ---------------- Gehaeuse -------------------------------------------
module koerper() {
  slab(0, 0, aus_b, aus_h, ecke_r, 0, front_d);
  hull() {
    slab(0, 0, aus_b, aus_h, ecke_r, front_d - 0.01, 0.01);
    slab(rue_x, rue_z, rue_b, rue_h, ruecken_r, aus_t - 0.01, 0.01);
  }
}

module gehaeuse() {
  wx = g_x + 1.0;  wz = g_z + 1.0;  wb = gb - 2;  wh = gh - 2;  wr = glas_r - 1;
  kz = (wz - 2.5) / 2;                          // Mitte des Kinns
  difference() {
    koerper();

    // Innenraum (hinten offen)
    translate([inn_x, front, inn_z]) cube([inn_b, inn_t + 1, inn_h]);

    // Bildschirm-Fenster mit schraeger Einfassung
    slab(wx, wz, wb, wh, wr, -1, front + 2);
    hull() {
      slab(wx - 2.5, wz - 2.5, wb + 5, wh + 5, wr + 2.5, -0.5, 0.5);
      slab(wx, wz, wb, wh, wr, 1.0, 0.01);
    }

    // Glas-Tasche innen (0.8 mm)
    translate([g_x - 0.2, front - 0.8, g_z - 0.2]) cube([gb + 0.4, 1, gh + 0.4]);

    if (direkt) {
      // USB-C-Mulde oben: Stecker taucht bis zur Buchse ein
      translate([usb_x, front + usb_tiefe, board_top - 0.6])
        linear_extrude(aus_h) offset(r=2.5) offset(delta=-2.5)
          square([stecker_b, stecker_d], center=true);
      // Bedienleiste unter dem Kinn: offene Nische vorne unten,
      // darin haengen die zwei Tasten-Knoepfe (von vorne sichtbar)
      translate([nische_x0, -1, -1])
        cube([nische_x1 - nische_x0, front + taste_tiefe + 5 + 1, nische_h + 1]);
      for (d = [pwr_y, boot_y])
        translate([kante_x(d), front + taste_tiefe, nische_h - 0.1]) cylinder(d=3.4, h=board_z);
    } else {
      // Tasten oben + Senkung fuer die Kappen
      for (d = [pwr_y, boot_y])
        translate([kante_x(d), front + taste_tiefe, board_top]) {
          cylinder(d=3.4, h=aus_h);
          translate([0,0,aus_h - board_top - 1.2]) cylinder(d=5.8, h=3);
        }
    }

    // Kinn: Regler-Mulden rechts, Power-LED links
    for (i = [0:3])
      translate([aus_b - 9 - i*4.6, -0.1, kz]) rotate([-90,0,0]) cylinder(d=2.8, h=0.7);
    translate([8, -0.1, kz]) rotate([-90,0,0]) cylinder(d=1.8, h=0.7);

    // Lueftungsschlitze oben und seitlich am Ruecken
    for (i = [0:4])
      translate([rue_x + 8, aus_t - 5 - i*2.6, inn_z + inn_h - 0.5]) cube([rue_b - 16, 1.2, 20]);
    for (i = [0:4])
      translate([-1, aus_t - 5 - i*2.6, inn_z + 6]) cube([aus_b + 2, 1.2, inn_h - 12]);

    // Aufnahme fuer den Fuss
    translate([zap_x, zap_y, -1]) cube([zap_b, zap_t, zap_h + 1]);
  }
  // Kinn: Netzschalter-Optik (erhaben)
  translate([12, 0, (g_z + 1.0 - 2.5)/2 - 1.6]) rotate([90,0,0])
    linear_extrude(0.8) rrect2d(6, 3.2, 1.2);
}

// ---------------- Standfuss (oval, Dreh-Fuss-Optik) ------------------
fuss_b = aus_b*0.78;
fuss_t = direkt ? aus_t*0.62 : aus_t*0.85;   // "direkt": vorne frei fuer die Tasten
module fuss() {
  hull() {
    translate([fuss_b/2, fuss_t/2, 0]) scale([fuss_b/2, fuss_t/2, 1]) cylinder(r=1, h=0.01, $fn=96);
    translate([fuss_b/2, fuss_t/2, 3]) scale([fuss_b/2 - 1.5, fuss_t/2 - 1.5, 1]) cylinder(r=1, h=0.01, $fn=96);
  }
  hull() {
    translate([fuss_b/2, fuss_t/2, 2.99]) scale([12, 6, 1]) cylinder(r=1, h=0.01, $fn=64);
    translate([fuss_b/2, fuss_t/2, 6.0])  scale([10, 5, 1]) cylinder(r=1, h=0.01, $fn=64);
  }
  translate([fuss_b/2 - (zap_b - 2*toleranz)/2, fuss_t/2 - (zap_t - 2*toleranz)/2, 5.99])
    cube([zap_b - 2*toleranz, zap_t - 2*toleranz, zap_h - 0.4]);
}

// ---------------- Rueckdeckel ----------------------------------------
module deckel() {
  lx = inn_x - rue_x;  lz = inn_z - rue_z;
  difference() {
    union() {
      linear_extrude(deckel_t) rrect2d(rue_b, rue_h, ruecken_r);
      translate([lx + toleranz, lz + toleranz, deckel_t])
        difference() {
          cube([inn_b - 2*toleranz, inn_h - 2*toleranz, lippe_t]);
          translate([1.6, 1.6, -1]) cube([inn_b - 2*toleranz - 3.2, inn_h - 2*toleranz - 3.2, lippe_t + 2]);
        }
      // Druckleisten: halten den Akku gegen die Platine
      for (dz = [0.3, 0.75])
        translate([lx + 4, lz + kp + (inn_h - kp)*dz - 1, deckel_t])
          cube([inn_b - 8, 2, lippe_t + 0.3 + tiefe_extra]);
    }
    if (!direkt) {
      // Kabeldurchfuehrung: Loch + Schlitz nach unten
      kx = usb_x - rue_x;  kz = inn_z + kp/2 - rue_z;
      translate([kx, kz, -1]) cylinder(d=kabel_d, h=deckel_t + lippe_t + 2);
      translate([kx - kabel_d/2, -1, -1]) cube([kabel_d, kz + 1, deckel_t + lippe_t + 2]);
    }
  }
}

// ---------------- Tasten-Stifte (2 Stueck) ---------------------------
module taste() {
  if (direkt) {
    // Stift: Kragen liegt innen auf dem Boden, Schaft geht nach unten in die Nische
    cylinder(d=5.0, h=0.6);
    cylinder(d=3.0, h=0.6 + (inn_z - nische_h) + 0.8 + 2.0);
  } else {
    // Stift von oben: Kappe aussen buendig in der Senkung
    cylinder(d=5.2, h=1.2);
    cylinder(d=3.0, h=aus_h - (board_top + knopf_ueber + 0.3));
  }
}

// Variante "direkt": sichtbarer Knopf, wird unten auf den Stift gesteckt
module knopf() {
  difference() {
    union() {
      cylinder(d=7.0, h=2.4);
      translate([0,0,2.4]) cylinder(d1=7.0, d2=6.2, h=0.6);
    }
    translate([0,0,0.8]) cylinder(d=3.15, h=3);   // Steckloch fuer den Stift
  }
}

// ---------------- Ausgabe --------------------------------------------
fuss_hoehe = 6;
color(farbe) {
if (teil == "gehaeuse") {
  gehaeuse();
} else if (teil == "deckel") {
  deckel();
} else if (teil == "fuss") {
  fuss();
} else if (teil == "tasten") {
  taste(); translate([8,0,0]) taste();
  if (direkt) { translate([0,10,0]) knopf(); translate([10,10,0]) knopf(); }
} else {
  translate([0, 0, fuss_hoehe]) gehaeuse();
  translate([aus_b/2 - fuss_b/2, zap_cy - fuss_t/2, 0]) fuss();
  translate([rue_x, aus_t + 10, rue_z + fuss_hoehe]) rotate([90,0,0]) translate([0,0,-deckel_t]) deckel();
  translate([aus_b + 8, 0, 0]) { taste(); translate([8,0,0]) taste();
    if (direkt) { translate([0,10,0]) knopf(); translate([10,10,0]) knopf(); } }
}
}
