module dud.semver2.checktest;

@safe pure private:
import std.exception : assertThrown, assertNotThrown;
import std.stdio;
import std.format : format;

import dud.semver2.checks;
import dud.semver2.parse;
import dud.semver2.semver;
import dud.semver2.versionrange;
import dud.semver2.versionunion;
import dud.semver2.exception;

immutable VersionRange vr1 = parseVersionRange(">=1.0.0 <=2.0.0").get();
immutable VersionRange vr2 = parseVersionRange(">=2.5.0 <=3.0.0").get();
immutable VersionRange vr3 = parseVersionRange(">=1.5.0 <=3.0.0").get();
immutable VersionRange vr4 = parseVersionRange(">=2.7.0 <=3.0.0").get();
immutable VersionRange vr5 = parseVersionRange(">3.0.0 <=4.0.0").get();

immutable VersionUnion vu1 = VersionUnion([vr1, vr4]);
immutable VersionUnion vu2 = VersionUnion([vr1, vr2]);
immutable VersionUnion vu3 = VersionUnion([vr3, vr4]);
immutable VersionUnion vu4 = VersionUnion([vr2, vr4]);
immutable VersionUnion vu5 = VersionUnion([vr1, vr5]);

immutable SemVer v1 = SemVer(0, 1, 0);
immutable SemVer v2 = SemVer(1, 1, 0);
immutable SemVer v3 = SemVer(2, 1, 0);
immutable SemVer v4 = SemVer(2, 5, 0);

unittest { // VersioUnion, VersionUnion
	assert( allowsAny(vu1, vu1));
	assert( allowsAny(vu1, vu2));
	assert( allowsAny(vu1, vu3));
	assert( allowsAny(vu1, vu4));
	assert( allowsAny(vu1, vu5));

	assert( allowsAny(vu2, vu1));
	assert( allowsAny(vu2, vu2));
	assert( allowsAny(vu2, vu3));
	assert( allowsAny(vu2, vu4));
	assert( allowsAny(vu2, vu5));

	assert( allowsAny(vu3, vu1));
	assert( allowsAny(vu3, vu2));
	assert( allowsAny(vu3, vu3));
	assert( allowsAny(vu3, vu4));
	assert( allowsAny(vu3, vu5));

	assert( allowsAny(vu4, vu1));
	assert( allowsAny(vu4, vu2));
	assert( allowsAny(vu4, vu3));
	assert( allowsAny(vu4, vu4));
	assert(!allowsAny(vu4, vu5));

	assert( allowsAny(vu5, vu1));
	assert( allowsAny(vu5, vu2));
	assert( allowsAny(vu5, vu3));
	assert(!allowsAny(vu5, vu4));
	assert( allowsAny(vu5, vu5));
}

unittest { // VersionUnion, VersionRange
	assert( allowsAny(vu1, vr1));
	assert( allowsAny(vu1, vr2));
	assert( allowsAny(vu1, vr3));
	assert( allowsAny(vu1, vr4));
	assert(!allowsAny(vu1, vr5));

	assert( allowsAny(vu2, vr1));
	assert( allowsAny(vu2, vr2));
	assert( allowsAny(vu2, vr3));
	assert( allowsAny(vu2, vr4));
	assert(!allowsAny(vu2, vr5));

	assert( allowsAny(vu3, vr1));
	assert( allowsAny(vu3, vr2));
	assert( allowsAny(vu3, vr3));
	assert( allowsAny(vu3, vr4));
	assert(!allowsAny(vu3, vr5));

	assert(!allowsAny(vu4, vr1));
	assert( allowsAny(vu4, vr2));
	assert( allowsAny(vu4, vr3));
	assert( allowsAny(vu4, vr4));
	assert(!allowsAny(vu4, vr5));

	assert( allowsAny(vu5, vr1));
	assert(!allowsAny(vu5, vr2));
	assert( allowsAny(vu5, vr3));
	assert(!allowsAny(vu5, vr4));
	assert( allowsAny(vu5, vr5));
}

unittest { // VersionUnion, SemVer
	assert(!allowsAny(vu1, v1));
	assert( allowsAny(vu1, v2));
	assert(!allowsAny(vu1, v3));
	assert(!allowsAny(vu1, v4));

	assert(!allowsAny(vu2, v1));
	assert( allowsAny(vu2, v2));
	assert(!allowsAny(vu2, v3));
	assert( allowsAny(vu2, v4));

	assert(!allowsAny(vu3, v1));
	assert(!allowsAny(vu3, v2));
	assert( allowsAny(vu3, v3));
	assert( allowsAny(vu3, v4));

	assert(!allowsAny(vu4, v1));
	assert(!allowsAny(vu4, v2));
	assert(!allowsAny(vu4, v3));
	assert( allowsAny(vu4, v4));

	assert(!allowsAny(vu5, v1));
	assert( allowsAny(vu5, v2));
	assert(!allowsAny(vu5, v3));
	assert(!allowsAny(vu5, v4));
}

unittest { // VersionRange, VersionUnion
	assert( allowsAny(vr1, vu1));
	assert( allowsAny(vr1, vu2));
	assert( allowsAny(vr1, vu3));
	assert(!allowsAny(vr1, vu4));
	assert( allowsAny(vr1, vu5));

	assert( allowsAny(vr2, vu1));
	assert( allowsAny(vr2, vu2));
	assert( allowsAny(vr2, vu3));
	assert( allowsAny(vr2, vu4));
	assert(!allowsAny(vr2, vu5));

	assert( allowsAny(vr3, vu1));
	assert( allowsAny(vr3, vu2));
	assert( allowsAny(vr3, vu3));
	assert( allowsAny(vr3, vu4));
	assert( allowsAny(vr3, vu5));

	assert( allowsAny(vr4, vu1));
	assert( allowsAny(vr4, vu2));
	assert( allowsAny(vr4, vu3));
	assert( allowsAny(vr4, vu4));
	assert(!allowsAny(vr4, vu5));

	assert(!allowsAny(vr5, vu1));
	assert(!allowsAny(vr5, vu2));
	assert(!allowsAny(vr5, vu3));
	assert(!allowsAny(vr5, vu4));
	assert( allowsAny(vr5, vu5));
}

unittest { // VersionRange, VersionRange
	assert( allowsAny(vr1, vr1));
	assert(!allowsAny(vr1, vr2));
	assert( allowsAny(vr1, vr3));
	assert(!allowsAny(vr1, vr4));
	assert(!allowsAny(vr1, vr5));

	assert(!allowsAny(vr2, vr1));
	assert( allowsAny(vr2, vr2));
	assert( allowsAny(vr2, vr3));
	assert( allowsAny(vr2, vr4));
	assert(!allowsAny(vr2, vr5));

	assert( allowsAny(vr3, vr1));
	assert( allowsAny(vr3, vr2));
	assert( allowsAny(vr3, vr3));
	assert( allowsAny(vr3, vr4));
	assert(!allowsAny(vr3, vr5));

	assert(!allowsAny(vr4, vr1));
	assert( allowsAny(vr4, vr2));
	assert( allowsAny(vr4, vr3));
	assert( allowsAny(vr4, vr4));
	assert(!allowsAny(vr4, vr5));

	assert(!allowsAny(vr5, vr1));
	assert(!allowsAny(vr5, vr2));
	assert(!allowsAny(vr5, vr3));
	assert(!allowsAny(vr5, vr4));
	assert( allowsAny(vr5, vr5));
}

unittest { // VersionRange, SemVer
	assert(!allowsAny(vr1, v1));
	assert( allowsAny(vr1, v2));
	assert(!allowsAny(vr1, v3));
	assert(!allowsAny(vr1, v4));

	assert(!allowsAny(vr2, v1));
	assert(!allowsAny(vr2, v2));
	assert(!allowsAny(vr2, v3));
	assert( allowsAny(vr2, v4));

	assert(!allowsAny(vr3, v1));
	assert(!allowsAny(vr3, v2));
	assert( allowsAny(vr3, v3));
	assert( allowsAny(vr3, v4));

	assert(!allowsAny(vr4, v1));
	assert(!allowsAny(vr4, v2));
	assert(!allowsAny(vr4, v3));
	assert(!allowsAny(vr4, v4));

	assert(!allowsAny(vr5, v1));
	assert(!allowsAny(vr5, v2));
	assert(!allowsAny(vr5, v3));
	assert(!allowsAny(vr5, v4));
}
