local utils = require('lua-slime.utils')

describe('pipeline', function()
  it('puts strings together like pipe commands for terminals', function()
    assert.are.same(utils.pipeline({'thing1', 'thing2'}), 'thing1 | thing2')
  end)
end)
