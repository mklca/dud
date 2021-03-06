module dud.sdlang.astaccess;

import dud.sdlang.ast;
import dud.sdlang.value;
import dud.sdlang.tokenmodule;

@safe pure:

struct AstAccessor(T,E) {
@safe pure:
	T value;
	this(T value) {
		this.value = value;
	}

	@property bool empty() const {
		return this.value is null;
	}

	@property ref E front() {
		return this.value.cur;
	}

	void popFront() {
		this.value = this.value.follow;
	}

	@property AstAccessor!(T,E) save() {
		return this;
	}
}

alias TagAccessor = AstAccessor!(Tags, Tag);
alias IDAccessor = AstAccessor!(IDFull, Token);
alias ValueAccessor = AstAccessor!(Values, Token);
alias AttributeAccessor = AstAccessor!(Attributes, Attribute);

TagAccessor tags(Root root) {
	return root is null
		? TagAccessor(null)
		: TagAccessor(root.tags);
}

TagAccessor tags(Tags t) {
	return TagAccessor(t);
}

TagAccessor tags(OptChild child) {
	return child is null
		? TagAccessor(null)
		: TagAccessor(child.tags);
}

IDAccessor key(Tag tag) {
	return tag is null
		? IDAccessor(null)
		: IDAccessor(tag.id);
}

AttributeAccessor attributes(Tag tag) {
	return AttributeAccessor(tag.attrs);
}

string identifier(Attribute attr) {
	auto a = IDAccessor(attr.id);
	return identifierImpl(a);
}

string fullIdentifier(Tag tag) {
	import std.array : appender;
	import std.algorithm.iteration : map, joiner;
	import std.algorithm.mutation : copy;

	auto app = appender!string;
	auto a = IDAccessor(tag.id);
	a
		.map!(it => it.value.get!string())
		.joiner(":")
		.copy(app);
	return app.data;

}

string identifier(Tag tag) {
	auto a = IDAccessor(tag.id);
	return identifierImpl(a);
}

string identifierImpl(IDAccessor a) {
	import std.exception : enforce;
	enforce(!a.empty, "Can get an ID from an empty IDAccessor");
	string cur;
	while(!a.empty) {
		cur = a.front.value.get!string();
		a.popFront();
	}
	return cur;
}

struct ValueRange {
@safe pure:
	ValueAccessor range;

	@property bool empty() const {
		return this.range.empty;
	}

	@property ref Token front() {
		return this.range.front;
	}

	void popFront() {
		this.range.popFront();
	}
}

ValueRange values(Values vals) {
	return ValueRange(ValueAccessor(vals));
}

ValueRange values(Tag tag) {
	return values(tag.vals);
}
