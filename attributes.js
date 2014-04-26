function Attributes() {

  var attributes = function(key, value) {
    key = '_'+key;
    if (arguments.length < 2) return attributes.values[key];
    attributes.values[key] = value;
    return this;
  }

  attributes.values = {};

  attributes.delete = Attributes.prototype.delete;

  return attributes;
};

Attributes.prototype.delete = function(key) {
  var value = this(key);
  this.values.delete(key);
  return value;
};


