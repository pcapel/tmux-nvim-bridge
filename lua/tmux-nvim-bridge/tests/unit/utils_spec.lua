local utils = require('tmux-nvim-bridge.utils')

describe('pipeline', function()
  it('puts strings together like pipe commands for terminals', function()
    assert.are.same(utils.pipeline({'thing1', 'thing2'}), 'thing1 | thing2')
  end)
end)

describe('arr_line', function()
  it('splits a line on the newline char', function()
    assert.are.same(utils.arr_line('thing1\nthing2'), {'thing1','thing2'})
  end)
end)
