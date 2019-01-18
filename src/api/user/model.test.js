import crypto from 'crypto'
import { User } from '.'

let user

beforeEach(async () => {
  user = await User.create({ fullName: 'user', email: 'a@a.com', password: '123456' })
})

describe('set email', () => {
  it('sets fullName automatically', () => {
    user.fullName = ''
    user.email = 'test@example.com'
    expect(user.fullName).toBe('test')
  })
})

describe('view', () => {
  it('returns simple view', () => {
    const view = user.view()
    expect(view).toBeDefined()
    expect(view.id).toBe(user.id)
    expect(view.fullName).toBe(user.fullName)
    expect(view.picture).toBe(user.picture)
  })

  it('returns full view', () => {
    const view = user.view(true)
    expect(view).toBeDefined()
    expect(view.id).toBe(user.id)
    expect(view.fullName).toBe(user.fullName)
    expect(view.email).toBe(user.email)
    expect(view.createdAt).toEqual(user.createdAt)
  })
})

describe('authenticate', () => {
  it('returns the user when authentication succeed', async () => {
    expect(await user.authenticate('123456')).toBe(user)
  })

  it('returns false when authentication fails', async () => {
    expect(await user.authenticate('blah')).toBe(false)
  })
})
