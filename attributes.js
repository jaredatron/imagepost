function Attributes() {
  var instance = this instanceof Attributes ? this :
    Object.create(Attributes.prototype)

  instance.values = {};

  function attributes(key, value) {
    if (arguments.length < 2) return this.get(key);
    instance.set(key, value);
    return this;
  }

  attributes.values = instance.values;
  attributes.delete = instance.delete.bind(instance);
  attributes.get    = instance.get.bind(instance);
  attributes.set    = instance.set.bind(instance);

  return attributes
};

Attributes.prototype.get = function(key) {
  return this.values[key];
};

Attributes.prototype.set = function(key, value) {
  this.values[key] = value;
  return this;
};

Attributes.prototype.delete = function(key) {
  var value = this.values[key];
  delete this.values[key];
  return value;
};


