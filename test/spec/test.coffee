'use strict'

describe 'Utils', () ->
  describe 'module maker', () ->
    it 'should return an object at depth', () ->
      window.module("one", "two")
      should.exist(window.one)
      should.exist(window.one.two)
      