import { success, notFound } from '../../services/response/'
import { User } from '.'

export const getScorers = async ({ querymen: { limit = 50, offset = 0 }, user }, res, next) => {
  try {
    const q = { organization: user.organization, role: 'user' }
    let [count, users] = await Promise.all([
      User.count(q),
      User.find(q)
        .skip(Number(offset))
        .limit(Number(limit))
    ])
    users = await users.map(u => u.view())

    return success(res, 200)({
      rows: users,
      count
    })
  } catch (err) {
    next(err)
  }
}

export const getScorer = async ({ params }, res, next) => {
  try {
    const user = await User.findById(params.id)
    if (!user) {
      return notFound(res)
    }
    return success(res, 201)(user.view())
  } catch (err) {
    next(err)
  }
}

export const getMe = async ({ user }, res, next) => {
  try {
    const u = await User.findById(user.id)
    return success(res, 201)(u.view())
  } catch (err) {
    next(err)
  }
}

export const inviteScorer = (req, res, next) => {
  // TODO
  return success(res, 201)({})
}

export const update = (req, res, next) => {
  // TODO
  return success(res, 201)({})
}
