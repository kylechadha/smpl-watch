import Toybox.Graphics;

module Colors {
    // Active mode colors
    const TIME   = 0xFFFFFF;
    const DATE   = 0x555555;
    const DIM    = 0x333333;
    const SEP    = 0x1C1C1C;
    const STEPS  = 0x38BDF8;
    const HR     = 0xF87171;
    const BAT    = 0x4ADE80;
    const SUN    = 0xE8A838;
    const MOON   = 0x7B8DC3;
    const TEAL   = 0x2DD4BF;
    const ACCENT = 0x818CF8;
    const TRACK  = 0x111111;
    const LABEL  = 0x2A2A2A;
    const BLACK  = 0x000000;
    const TRANS  = Graphics.COLOR_TRANSPARENT;

    // Tactical colors
    const OLIVE  = 0xA3A651;
    const SAND   = 0xD4D4A0;
    const DIM_OLIVE = 0x5A5A30;

    // Retro LCD
    const AMBER    = 0xFFB000;
    const DIM_AMBER = 0x664800;

    // AOD mode colors — all accents become dim gray
    const AOD_TIME  = 0x777777;
    const AOD_DATE  = 0x282828;
    const AOD_DIM   = 0x1A1A1A;
    const AOD_SEP   = 0x0E0E0E;
    const AOD_ACC   = 0x282828;
    const AOD_TRACK = 0x080808;
    const AOD_LABEL = 0x151515;

    // Return the right color for the current mode
    function time(aod as Boolean) as Number {
        return aod ? AOD_TIME : TIME;
    }

    function date(aod as Boolean) as Number {
        return aod ? AOD_DATE : DATE;
    }

    function dim(aod as Boolean) as Number {
        return aod ? AOD_DIM : DIM;
    }

    function sep(aod as Boolean) as Number {
        return aod ? AOD_SEP : SEP;
    }

    function steps(aod as Boolean) as Number {
        return aod ? AOD_ACC : STEPS;
    }

    function hr(aod as Boolean) as Number {
        return aod ? AOD_ACC : HR;
    }

    function bat(aod as Boolean) as Number {
        return aod ? AOD_ACC : BAT;
    }

    function sun(aod as Boolean) as Number {
        return aod ? AOD_ACC : SUN;
    }

    function accent(aod as Boolean) as Number {
        return aod ? AOD_ACC : ACCENT;
    }

    function teal(aod as Boolean) as Number {
        return aod ? AOD_ACC : TEAL;
    }

    function track(aod as Boolean) as Number {
        return aod ? AOD_TRACK : TRACK;
    }

    function label(aod as Boolean) as Number {
        return aod ? AOD_LABEL : LABEL;
    }
}
