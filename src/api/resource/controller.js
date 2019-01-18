import { success } from '../../services/response/'
import { Resource } from '.'

export const getAll = async ({ querymen: { limit = 50, offset = 0 }, user }, res, next) => {
  try {
    const q = { organization: user.organization }
    let [count, resources] = await Promise.all([
      Resource.count(q),
      Resource.find(q)
        .skip(Number(offset))
        .limit(Number(limit))
    ])
    resources = await resources.map(r => r.view())

    return success(res, 200)({
      rows: resources,
      count
    })
  } catch (err) { next(err) }
}
